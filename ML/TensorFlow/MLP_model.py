import numpy
import tensorflow as tf
from matplotlib import pyplot as plt
import numpy as np

# 多层感知机（MLP）
# source: https://tf.wiki/zh_hans/basic/models.html#model-layer

# 处理数据集
# 加载MNIST数据



class MNISTLoader():
    def __init__(self):
        # 从网络获取数据集
        mnist = tf.keras.datasets.mnist
        (self.train_data, self.train_label), (self.test_data, self.test_label) = mnist.load_data()
        # print(self.train_data[0])
        # print("train_data.shape:", self.train_data.shape)
        # MNIST中的图像默认为uint8（0-255的数字）。以下代码将其归一化到0-1之间的浮点数，并在最后增加一维作为颜色通道
        self.train_data = np.expand_dims(self.train_data.astype(np.float32) / 255.0, axis=-1)
        self.test_data = np.expand_dims(self.test_data.astype(np.float32) / 255.0, axis=-1)
        self.train_label = self.train_label.astype(np.int32)
        self.test_label = self.test_label.astype(np.int32)
        self.num_train_data, self.num_test_data = self.train_data.shape[0], self.test_data.shape[0]
        # print(self.train_data.shape)
    def get_batch(self, batch_size):
        # 从数据集中随机取出batch_size个元素并返回
        index = np.random.randint(0, self.num_train_data, batch_size)
        # print(index)
        return self.train_data[index, :], self.train_label[index]
# print( MNISTLoader().get_batch(10))
class MLP(tf.keras.Model):
    def __init__(self):
        super().__init__()
        # Flatten层将除第一维（batch_size）以外的维度展平
        self.flatten = tf.keras.layers.Flatten()
        self.dense1 = tf.keras.layers.Dense(units=100, activation=tf.nn.relu)
        self.dense2 = tf.keras.layers.Dense(units=10)

    def call(self, inputs, training=None, mask=None):   # [batch_size, 28, 28, 1]
        x = self.flatten(inputs)                        # [batch_size, 784]
        x = self.dense1(x)                              # [batch_size, 100]
        x = self.dense2(x)                              # [batch_size, 10]
        output = tf.nn.softmax(x)   # 归一化指数函数
        return output

# 训练模型
num_epochs = 5
batch_size = 50
learning_rate = 0.001

model = MLP()
data_loader = MNISTLoader()
optimizer = tf.keras.optimizers.Adam(learning_rate=learning_rate)

num_batches = int(data_loader.num_train_data // batch_size * num_epochs)
for batch_index in range(num_batches):
    X, y = data_loader.get_batch(batch_size)
    with tf.GradientTape() as tape:
        y_pred = model(X)
        # 交叉商函数计算损失函数
        loss = tf.keras.losses.sparse_categorical_crossentropy(y_true=y, y_pred=y_pred)
        loss = tf.reduce_mean(loss)
        print("batch %d: loss %f" % (batch_index, loss.numpy()))
    grads = tape.gradient(loss, model.variables)
    optimizer.apply_gradients(grads_and_vars=zip(grads, model.variables))

# 评估
sparse_categorical_accuracy = tf.keras.metrics.SparseCategoricalAccuracy()
num_batches = int(data_loader.num_test_data // batch_size)
for batch_index in range(num_batches):
    start_index, end_index = batch_index * batch_size, (batch_index + 1) * batch_size
    y_pred = model.predict(data_loader.test_data[start_index: end_index])
    sparse_categorical_accuracy.update_state(y_true=data_loader.test_label[start_index: end_index], y_pred=y_pred)
print("test acc: ", sparse_categorical_accuracy.result())

