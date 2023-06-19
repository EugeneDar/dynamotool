import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import norm


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


def plot_ecdf(data):
    x = np.sort(data)
    y = np.arange(1, len(x) + 1) / len(x)

    fig, ax = plt.subplots()

    ax.plot(x, y, marker='o', linestyle='-', color='blue')
    ax.set_xlabel('Percentages')
    ax.set_ylabel('Probability')
    ax.set_title('Empirical Cumulative Distribution Function')

    mean_value = np.mean(x)
    ax.axvline(x=mean_value, color='red', linestyle='--', label='Mean: {:.2f}'.format(mean_value))

    textstr = '\n'.join(('Mean: {:.2f}'.format(mean_value),
                         'Standard Deviation: {:.2f}'.format(np.std(x))))
    props = dict(boxstyle='round', facecolor='white', edgecolor='gray')
    ax.text(0.05, 0.95, textstr, transform=ax.transAxes, fontsize=10,
            verticalalignment='top', horizontalalignment='left', bbox=props)

    mu = np.mean(x)
    sigma = np.std(x)
    xmin, xmax = ax.get_xlim()
    x_range = np.linspace(xmin, xmax, 100)
    cdf = norm.cdf(x_range, mu, sigma)
    ax.plot(x_range, cdf, color='green')

    ax.legend(['Empirical CDF', 'Mean', 'Normal Distribution'], loc='lower right')

    plt.show()


file_path = 'data.csv'
data = read_percentages_from_file(file_path)
data = remove_outliers(data)
plot_ecdf(data)
