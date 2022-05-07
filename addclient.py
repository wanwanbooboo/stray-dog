"""ソケットを使ってADDプロトコルを実装したクライアントのスクリプト"""

import socket
import struct

def send_msg(sock,msg):
  """ソケットに引数のバイト列を書き込む関数"""
  #これまでに送信できたバイト数
  total_sent_len=0
  #送信したいバイト数
  total_msg_len=len(msg)
  #まだ送信したいデータが残っているかを判定する
  while total_sent_len<total_msg_len:
    #ソケットにバイト列を書き込んで、書き込めたバイト数を得る
    sent_len=sock.send(msg[total_sent_len:])
    #まったく書き込めなかったらソケットの接続が終了している
    if sent_len==0:
      raise RuntimeError('socket connection broken')
    #書き込めた分を加算する
    total_sent_len +=sent_len


def recv_msg(sock,total_msg_size):
  """ソケットから接続が終わるまでバイト列を読み込むジェネレータ関数"""
  #これまでに受信できたバイト数
  total_recv_size=0
  #指定したバイト数を受信できたか確認する
  while total_recv_size<total_msg_size:
    #ソケットから指定したバイト数を読み込む
    received_chunk=sock.recv(total_msg_size-total_recv_size)
    #まったく読めなかったときは接続が終了している
    if len(received_chunk)==0:
      raise RuntimeError('socket connection broken')
    #受信したバイト列を返す。複数あるとyieldはリストで返す
    yield received_chunk
    #受信できたバイト数を加算する
    total_recv_size+=len(received_chunk)


def main():
  """スクリプトして実行されたときに呼び出されるメイン関数"""
  #socketインスタンスの生成。AF_INETはIPv4、SOCK_STREAMはTCPを使用することを意味する
  client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
  #接続先のIPアドレスとポートを指定してサーバに接続する
  client_socket.connect(('127.0.0.1',54321))
  #足し算したい値を設定する
  operand1,operand2=1000,2000
  #送信する値の確認
  print(f'operand1:{operand1},operand2:{operand2}')
  #ネットワークバイトオーダーのバイト列に変換する
  request_msg=struct.pack('!ii',operand1,operand2)
  #ソケットにリクエストのバイト列を書き込む
  send_msg(client_socket,request_msg)
  #書き込んだバイト列を表示する
  print(f'sent:{request_msg}')
  #ソケットからレスポンスのバイト列を読み込む。バイト列は空白を区切り文字としてjoinする
  received_msg=b''.join(recv_msg(client_socket,8))
  #読み込んだバイト列を表示する
  print(f'received:{received_msg}')
  #64ビットの整数として表示する
  (added_value,)=struct.unpack('!q',received_msg)
  #解釈した値を表示する
  print(f'result:{added_value}')
  #使い終わったソケットを閉じる
  client_socket.close()


if __name__=='__main__':
  main()
