import dash
import dash_bootstrap_components as dbc
import dash_core_components as dcc
import dash_html_components as html
import pandas as pd
from dash.dependencies import Input, Output, State
import struct
import socket
import base64
import io

# Inicializa o aplicativo Dash
app = dash.Dash(__name__, external_stylesheets=[dbc.themes.BOOTSTRAP])

# Função para ler o arquivo CSV de um conteúdo base64
def ler_csv_conteudo(contents):
    content_type, content_string = contents.split(',')
    decoded = base64.b64decode(content_string)
    df = pd.read_csv(io.StringIO(decoded.decode('utf-8')), delimiter=',')
    return df

# Função para serializar os dados em um formato adequado para envio via UDP
def serializar_dados(dados):
    payload = b''  # Inicializa o payload como um array de bytes vazio
    for _, linha in dados.iterrows():
        payload += struct.pack('d', linha['Latitude'])
        payload += struct.pack('d', linha['Longitude'])
        payload += struct.pack('d', linha['targetHeading'])
        payload += struct.pack('d', linha['targetTrottle'])
        payload += struct.pack('d', linha['searchRadius'])
    return payload

# Função para enviar os dados via UDP
def enviar_via_udp(payload, rota):
    UDP_IP = "10.200.83.53"  # Endereço IP de destino (substitua pelo IP desejado)
    UDP_PORT = 5015  # Porta UDP de destino

    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    header = struct.pack('i', rota)  # Empacota o número da rota como um int32
    sock.sendto(header + payload, (UDP_IP, UDP_PORT))  # Envia o cabeçalho e o payload juntos
    sock.close()

# Layout do aplicativo Dash
app.layout = dbc.Container([
    dbc.Row([
        dbc.Col(html.H1("Dashboard de Envio de Rotas via UDP"), className="mb-2")
    ]),
    dbc.Row([
        dbc.Col(dcc.Upload(
            id='upload-data',
            children=html.Div(['Arraste e solte ou ', html.A('selecione um arquivo CSV')]),
            style={
                'width': '100%',
                'height': '60px',
                'lineHeight': '60px',
                'borderWidth': '1px',
                'borderStyle': 'dashed',
                'borderRadius': '5px',
                'textAlign': 'center',
                'margin': '10px'
            },
            multiple=False
        ), className="mb-2"),
    ]),
    dbc.Row([
        dbc.Col(html.Div(id='upload-status', children='Nenhum arquivo carregado'), className="mb-2")
    ]),
    dbc.Row([
        dbc.Col(dcc.Dropdown(id='dropdown-rotas', placeholder='Selecione uma rota'), className="mb-2")
    ]),
    dbc.Row([
        dbc.Col(html.Button('Enviar Rota via UDP', id='botao-enviar', n_clicks=0), className="mb-2")
    ]),
    dbc.Row([
        dbc.Col(html.Div(id='output-mensagem'))
    ])
])

@app.callback(
    Output('dropdown-rotas', 'options'),
    Output('dropdown-rotas', 'value'),
    Output('upload-status', 'children'),
    Input('upload-data', 'contents'),
    State('upload-data', 'filename')
)
def atualizar_dropdown(contents, filename):
    if contents is not None:
        df = ler_csv_conteudo(contents)
        rotas = df['Route'].unique()
        options = [{'label': f'Rota {rota}', 'value': rota} for rota in rotas]
        status_message = f'Arquivo {filename} carregado com sucesso!'
        return options, None, status_message
    return [], None, 'Nenhum arquivo carregado'

@app.callback(
    Output('output-mensagem', 'children'),
    Input('botao-enviar', 'n_clicks'),
    State('dropdown-rotas', 'value'),
    State('upload-data', 'contents')
)
def enviar_rota(n_clicks, rota_selecionada, contents):
    if n_clicks > 0 and rota_selecionada is not None and contents is not None:
        df = ler_csv_conteudo(contents)
        dados_rota = df[df['Route'] == rota_selecionada]
        payload = serializar_dados(dados_rota)
        enviar_via_udp(payload, int(rota_selecionada))
        return f'Dados da Rota {rota_selecionada} enviados com sucesso!'
    return ''

if __name__ == '__main__':
    app.run_server(debug=True)
