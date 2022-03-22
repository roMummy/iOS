import os
import sys

import tensorflow as tf
from tensorflow import keras
import keras_tuner as kt


# 获取数据集
fashion_mnist = keras.datasets.fashion_mnist
(train_images, train_labels), (test_images, test_labels) = fashion_mnist.load_data()

# 归一化
train_images = train_images / 255.0
test_images = test_images / 255.0

# 定义模型
def model_builder(hp):
    model = tf.keras.Sequential()
    model.add(tf.keras.layers.Flatten(input_shape=(28,28)))

    hp_units = hp.Int('units', min_value=32, max_value=512, step=32)
    model.add(tf.keras.layers.Dense(units=hp_units, activation='relu'))
    model.add(tf.keras.layers.Dense(10))

    hp_learning_rate = hp.Choice('learning_rate', values=[1e-2, 1e-3, 1e-4])

    model.compile(optimizer=tf.keras.optimizers.Adam(learning_rate=hp_learning_rate),
                  loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True),
                  metrics=['accuracy'])
    return model

# 超调
path = os.path.dirname(__file__) + "/my_dir"
tuner = kt.Hyperband(model_builder,
                     objective='val_accuracy',
                     max_epochs=10,
                     factor=3,
                     directory=path,
                     project_name='intro_to_kt')


# 创建回调以在验证损失达到特定值后提前停止训练。
stop_early = tf.keras.callbacks.EarlyStopping(monitor='val_loss', patience=5)
tuner.search(train_images, train_labels, epochs=50, validation_split=0.2, callbacks=[stop_early])
best_hps = tuner.get_best_hyperparameters(num_trials=1)[0]
print(f"""
The hyperparameter search is complete. The optimal number of units in the first densely-connected
layer is {best_hps.get('units')}  and the optimal learning rate for the optimizer
is {best_hps.get('learning_rate')}.
""")

# 训练模型 使用从搜索中获得的超参数找到训练模型的最佳周期数。
model = tuner.hypermodel.build(best_hps)
history = model.fit(train_images, train_labels, epochs=50, validation_split=0.2)

val_acc_per_epoch = history.history['val_accuracy']
best_epoch = val_acc_per_epoch.index(max(val_acc_per_epoch)) + 1
print('Best epoch: %d' % (best_epoch,))

# 重新实例化超模型并使用上面的最佳周期数对其进行训练。
hypermodel = tuner.hypermodel.build(best_hps)
hypermodel.fit(train_images, train_labels, epochs=best_epoch, validation_split=0.2)

# 评估
eval_result = hypermodel.evaluate(test_images, test_labels)
print("[test loss, test accuracy]:", eval_result)
