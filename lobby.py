from serial import Serial
from threading import Thread
from board import Board

from random import randint
from time import sleep

import os
os.system('cls' if os.name == 'nt' else 'clear')

import serial

class RS232:
    def __init__(self, port_number):
        self.port_number = port_number
        self.serial = Serial("COM%d" % port_number, timeout=0.1)

    def read(self, bytes=255):
        return self.serial.read(bytes).decode("utf-8")

    def write(self, data):
        self.serial.write(str(data).encode())

    def close(self):
        self.serial.close()

    def __str__(self):
        return "COM%s" % self.port_number

def new_ball():
    return randint(1, 76)

n = 3
rx_n = 6

try:
    tx = RS232(n)
    app_n = 1
except:
    try:
        n += 2
        tx = RS232(n)
        rx = RS232(4)
        app_n = 2
    except:
        try:
            n += 2
            tx = RS232(n)
            rx = RS232(6)
            app_n = 3
        except:
            try:
                n += 2
                tx = RS232(n)
                rx = RS232(8)
                app_n = 4
            except:
                print("No more available spots...")
                exit

b = Board()
bingo_print = True

if app_n == 1:
    print("Insert a number of players")
    n_players = int(input("> "))

    while n_players < 2 or n_players > 4:
        print("There must be between 2 and 4 players")
        n_players = int(input("> "))

    if n_players == 2:
        rx = RS232(6)
    elif n_players == 3:
        rx = RS232(8)
    elif n_players == 4:
        rx = RS232(10)

    input("Press any key when ready")
    print("Good luck!")

    i = 0

    tx.write("")

    while True:
        last_ball = rx.read()

        if last_ball == "bingo":
                if bingo_print:
                    print("You lost :(")
                    tx.write("bingo")
                    bingo_print = False
                    input("Press any key")
                    quit()
        else:
            if last_ball != "" or i == 0:
                ball = new_ball()
                b.play(ball)

                if b.win:
                    if bingo_print:
                        print("BINGO! You won! :D")
                        tx.write("bingo")
                        bingo_print = False
                        input("Press any key")
                        quit()
                else:
                    tx.write(ball)
                    i += 1
    
else:    
    print("Hello, Player %s" % app_n)
    while True:
        ball = rx.read()

        if ball == "bingo":
            if bingo_print:
                print("You Lost :(")
                tx.write("bingo")
                bingo_print = False
                input("Press any key")
                quit()

        else:
            if ball != "":
                b.play(ball)

                if b.win:
                    if bingo_print:
                        print("BINGO! You won! :D")
                        tx.write("bingo")
                        bingo_print = False
                        input("Press any key")
                        quit()
                else:
                    tx.write(ball)