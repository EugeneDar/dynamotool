import numpy as np
import matplotlib.pyplot as plt


def remove_outliers(data, threshold=3):
    mean = np.mean(data)
    std = np.std(data)
    filtered_data = [x for x in data if (x - mean) < threshold * std]
    return filtered_data


def read_percentages_from_file(file_path):
    percentages = []

    with open(file_path, 'r') as file:
        lines = file.readlines()

        for line in lines:
            values = line.strip().split(',')
            percentage_str = values[-1].strip('%')
            try:
                percentage = float(percentage_str)
                percentages.append(percentage)
            except ValueError:
                pass

    return percentages


def plot_ecdf(percentages):
    x = np.sort(data)
    y = np.arange(1, len(x) + 1) / len(x)

    # Создание графика
    fig, ax = plt.subplots()

    ax.plot(x, y, marker='o', linestyle='-', color='blue')
    ax.set_xlabel('Проценты')
    ax.set_ylabel('Вероятность')
    ax.set_title('Поточечная функция распределения')

    # Добавление вертикальной прямой для отображения среднего значения
    mean_value = np.mean(x)
    ax.axvline(x=mean_value, color='red', linestyle='--', label='Среднее: {:.2f}'.format(mean_value))

    # Добавление информации о среднем и среднеквадратичном отклонении в левый верхний угол графика
    textstr = '\n'.join(('Среднее: {:.2f}'.format(mean_value),
                         'Стандартное отклонение: {:.2f}'.format(np.std(x))))
    props = dict(boxstyle='round', facecolor='white', edgecolor='gray')
    ax.text(0.05, 0.95, textstr, transform=ax.transAxes, fontsize=10,
            verticalalignment='top', horizontalalignment='left', bbox=props)

    # Отображение графика
    plt.show()


file_path = 'data.csv'  # Путь к вашему файлу данных
data = read_percentages_from_file(file_path)
data = remove_outliers(data)
plot_ecdf(data)
