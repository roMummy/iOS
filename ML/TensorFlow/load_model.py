import os.path

import tensorflow as tf
from tensorflow import keras
from keras.models import Sequential
from keras.layers import Dense, Activation, Flatten, Softmax


# 加载模型
# new_model = tf.keras.models.load_model("saved_model/my_model")
# new_model.summary()

# 加载H5模型
new_model = tf.keras.models.load_model("saved_model/hdf5/model.h5")
new_model.summary()



# 获取数据集
fashion_mnist = keras.datasets.fashion_mnist
(train_images, train_labels), (test_images, test_labels) = fashion_mnist.load_data()

# 评估准确率
loss, acc = new_model.evaluate(test_images, test_labels, verbose=2)
print("acc: {:5.2f}".format(100*acc))

# 获取模型
checkpoint_path = "training_1/cp.ckpt"
checkpoint_dir = os.path.dirname(checkpoint_path)

latest = tf.train.latest_checkpoint(checkpoint_dir)
print(latest)

def create_model():
    model = Sequential([
        # 第一层变成一维数组
        Flatten(input_shape=(28, 28)),
        # 第一个 Dense 层有 128 个节点（或神经元
        Dense(128, activation='relu'),
        # 第二个（也是最后一个）层会返回一个长度为 10 的 logits 数组
        Dense(10)
    ])
    model.compile(
        optimizer='adam',
        loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True),
        metrics=['accuracy']
    )
    return model

# 创建模型
model = create_model()
# 加载权重
# model.load_weights(latest)
# 评估准确率
loss, acc = model.evaluate(test_images, test_labels, verbose=2)
print("acc: {:5.2f}".format(100*acc))

# 训练模型
model.fit(train_images, train_labels, epochs=20)
# 保存模型
model.save("saved_model/hdf5/model.h5")
