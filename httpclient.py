"""ソケットを使ってHTTPクライアントを実装したスクリプト"""

import socket

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


def recv_msg(sock,chunk_len=1024):
  """ソケットから接続が終わるまでバイト列を読み込むジェネレータ関数"""
  while true:
    #ソケットから指定したバイト数を読み込む
    received_chunk=sock.recv(chunk_len)
    #まったく読めなかったときは接続が終了している
    if len(received_chunk)==0:
      break
    #受信したバイト列を返す。複数あるとyieldはリストで返す
    yield received_chunk


def main():
  """スクリプトとして実行されたときに呼び出されるメイン関数"""
  #socketインスタンスの生成。AF_INETはIPv4、SOCK_STREAMはTCPを使用することを意味する
  client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
  #接続先のIPアドレスとポートを指定してサーバに接続する
  client_socket.connect(('127.0.0.1',80))
  #HTTPサーバからドキュメント（index.html）を取得するためのGETリクエスト
  request_text='GET / HTTP/1.0\r\n\r\n'
  #ソケットにデータを書き込むためには文字列ではなくバイト列が必要なのでエンコードする
  request_bytes =request_text.encode('ASCII')
  #ソケットにリクエストのバイト列を書き込む
  send_msg(client_socket,request_bytes)
  #ソケットからレスポンスのバイト列を読み込む。バイト列は空白を区切り文字としてjoinする
  received_bytes=b''.join(recv_msg(client_socket))
  #バイト列を文字列へデコード
  received_text=received_bytes.decode('ASCII')
  #得られた文字列を表示
  print(received_text)
  #使い終わったソケットを閉じる
  client_socket.close()


if __name__=='__main__':
  main()
