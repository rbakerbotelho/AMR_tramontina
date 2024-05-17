import csv
import struct
import socket

# Função para ler o arquivo CSV e retornar os dados como uma lista de dicionários
def ler_csv(nome_arquivo):
    with open(nome_arquivo, newline='') as csvfile:
        reader = csv.DictReader(csvfile, delimiter=',')
        return list(reader)

# Função para serializar os dados em um formato adequado para envio via UDP
def serializar_dados(dados):
    payload = b''  # Inicializa o payload como um array de bytes vazio
    for linha in dados:
        payload += struct.pack('d', float(linha['Latitude'].replace(',', '.')))
        payload += struct.pack('d', float(linha['Longitude'].replace(',', '.')))
        payload += struct.pack('d', float(linha['targetHeading'].replace(',', '.')))
        payload += struct.pack('d', float(linha['targetTrottle'].replace(',', '.')))
        payload += struct.pack('d', float(linha['searchRadius'].replace(',', '.')))
    return payload

# Função para enviar os dados via UDP
def enviar_via_udp(payload, rota):
    UDP_IP = "10.200.83.53"  # Endereço IP de destino (no exemplo, é o localhost)
    UDP_PORT = 5015  # Porta UDP de destino

    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    header = struct.pack('i', rota)  # Empacota o número da rota como um int32
    sock.sendto(header + payload, (UDP_IP, UDP_PORT))  # Envia o cabeçalho e o payload juntos
    sock.close()

# Função principal
def main():
    nome_arquivo = 'route7.csv'  # Nome do arquivo CSV
    dados = ler_csv(nome_arquivo)  # Lê os dados do arquivo CSV

    rotas_disponiveis = set([linha['Route'] for linha in dados])  # Obtém as rotas disponíveis
    print("Rotas disponíveis:", rotas_disponiveis)

    rota_escolhida = int(input("Escolha uma rota: "))  # Solicita ao usuário que escolha uma rota

    # Filtra os dados para obter apenas os da rota escolhida
    dados_rota = [linha for linha in dados if linha['Route'] == str(rota_escolhida)]

    if dados_rota:
        payload = serializar_dados(dados_rota)  # Serializa os dados da rota escolhida
        enviar_via_udp(payload, rota_escolhida)  # Envia os dados via UDP
        print("Dados enviados com sucesso!")
    else:
        print("Rota inválida ou sem dados.")

if __name__ == "__main__":
    main()
