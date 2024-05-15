'''
import math
import csv

def load_lanes(file_path):
    lanes = []
    with open(file_path, "r") as file:
        for line in file:
            if line.startswith("LANE"):
                parts = line.strip().split()
                lanes.append(tuple(map(float, parts[1:])))
    return lanes

def find_lane_by_endpoint(lanes, x, y):
    for lane in lanes:
        if (x, y) == lane[:2]:  # verifica se o ponto final corresponde ao início do lane
            lanes.remove(lane)
            return lane
        elif (x, y) == lane[2:]:  # verifica se o ponto final corresponde ao final do lane
            lanes.remove(lane)
            return (lane[2], lane[3], lane[0], lane[1])  # inverte o lane para corresponder ao início do próximo lane
    return None

def calculate_yaw(point1, point2):
    dx = point2[0] - point1[0]
    dy = point2[1] - point1[1]
    yaw = math.atan2(dy, dx) * (180 / math.pi)  # converte de radianos para graus
    return yaw

def create_continuous_path(lanes, start_point):
    if start_point not in [(lane[0], lane[1]) for lane in lanes] and start_point not in [(lane[2], lane[3]) for lane in lanes]:
        print("O ponto inicial fornecido não corresponde ao início ou ao fim de nenhuma das Lanes.")
        return []

    continuous_path = [start_point]
    used_lanes = []

    current_point = start_point
    
    while True:
        next_lane = find_lane_by_endpoint(lanes, *current_point)
        if next_lane is None:
            break
        
        # Verifica se o ponto atual é o ponto inicial ou final do próximo Lane
        if (current_point[0], current_point[1]) == (next_lane[0], next_lane[1]):
            continuous_path.append((next_lane[2], next_lane[3]))
            current_point = (next_lane[2], next_lane[3])
        else:
            continuous_path.append((next_lane[0], next_lane[1]))
            current_point = (next_lane[0], next_lane[1])
        
        # Adiciona o Lane usado à lista de Lanes usadas
        used_lanes.append(next_lane)
    
    return continuous_path

def write_csv_file(file_path, continuous_path):
    with open(file_path, "w", newline="") as file:
        writer = csv.writer(file)
        for i in range(len(continuous_path)):
            if i == 0:
                yaw = calculate_yaw(continuous_path[i], continuous_path[i+1])
            else:
                yaw = calculate_yaw(continuous_path[i-1], continuous_path[i])
            writer.writerow([continuous_path[i][0], continuous_path[i][1], yaw])

def main():
    lanes = load_lanes("lanes.vmap")
    start_point = (50.4551, -46.0941)
    continuous_path = create_continuous_path(lanes, start_point)
    
    print("Caminho contínuo com yaw:")
    for i in range(len(continuous_path)):
        if i == 0:
            yaw = calculate_yaw(continuous_path[i], continuous_path[i+1])
        else:
            yaw = calculate_yaw(continuous_path[i-1], continuous_path[i])
        print(f"Ponto: {continuous_path[i]}, Yaw: {yaw}")
    
    write_csv_file("result.csv", continuous_path)
    print("Resultados escritos em 'result.csv'.")

if __name__ == "__main__":
    main()
'''


import math
import csv
import os

TARGET_THROTTLE_VELOCITY = 140  # Constant target throttle velocity in mm/s

def load_lanes(file_path):
    lanes = []
    with open(file_path, "r") as file:
        for line in file:
            if line.startswith("LANE"):
                parts = line.strip().split()
                lanes.append(tuple(map(float, parts[1:])))
    return lanes

def find_lane_by_endpoint(lanes, x, y):
    for lane in lanes:
        if (x, y) == lane[:2]:
            lanes.remove(lane)
            return lane
        elif (x, y) == lane[2:]:
            lanes.remove(lane)
            return (lane[2], lane[3], lane[0], lane[1])
    return None

def calculate_yaw(point1, point2):
    dx = point2[0] - point1[0]
    dy = point2[1] - point1[1]
    yaw = math.atan2(dy, dx) * (180 / math.pi)
    return yaw

def create_continuous_path(lanes, start_point):
    if start_point not in [(lane[0], lane[1]) for lane in lanes] and start_point not in [(lane[2], lane[3]) for lane in lanes]:
        print("O ponto inicial fornecido não corresponde ao início ou ao fim de nenhuma das Lanes.")
        return []

    continuous_path = [start_point]
    used_lanes = []

    current_point = start_point
    
    while True:
        next_lane = find_lane_by_endpoint(lanes, *current_point)
        if next_lane is None:
            break
        
        if (current_point[0], current_point[1]) == (next_lane[0], next_lane[1]):
            continuous_path.append((next_lane[2], next_lane[3]))
            current_point = (next_lane[2], next_lane[3])
        else:
            continuous_path.append((next_lane[0], next_lane[1]))
            current_point = (next_lane[0], next_lane[1])
        
        used_lanes.append(next_lane)
    
    return continuous_path

def write_csv_file(file_path, continuous_path):
    with open(file_path, "w", newline="") as file:
        writer = csv.writer(file)
        
        # Write the header
        writer.writerow(["X", "Y", "Yaw", "targetThrottle"])
        
        # Write the data rows
        for i in range(len(continuous_path)):
            if i == 0:
                yaw = calculate_yaw(continuous_path[i], continuous_path[i+1])
            else:
                yaw = calculate_yaw(continuous_path[i-1], continuous_path[i])
            writer.writerow([continuous_path[i][0], continuous_path[i][1], yaw, TARGET_THROTTLE_VELOCITY])


def main():

    # import glob 
    #vmap_files = glob.glob("*.vmap")
    
    filename = "mapa_aplicacao_fundos_20240514.vmap"
    lanes = load_lanes(filename)
    start_point = (50.4551, -46.0941)
    continuous_path = create_continuous_path(lanes, start_point)
    
    print("Caminho contínuo com yaw e velocidade constante de", TARGET_THROTTLE_VELOCITY, "mm/s:")
    for i in range(len(continuous_path)):
        if i == 0:
            yaw = calculate_yaw(continuous_path[i], continuous_path[i+1])
        else:
            yaw = calculate_yaw(continuous_path[i-1], continuous_path[i])
        print(f"Ponto: {continuous_path[i]}, Yaw: {yaw}, Velocidade: {TARGET_THROTTLE_VELOCITY}")
    
    base_name = os.path.basename(filename)  # Extract the base filename
    filename_without_extension = os.path.splitext(base_name)[0]  # Remove the extension
    csv_filename = filename_without_extension + '_result.csv'


    write_csv_file(csv_filename, continuous_path)
    print("Resultados escritos em 'result.csv'.")

if __name__ == "__main__":
    main()
