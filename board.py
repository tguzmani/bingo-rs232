import time
from cell import Cell
import sys
from utils import random_sample
from random import randint

NUM_CELLS = 5
FORMAT_STR = "%-4s " * 5

class Board:
    def __init__(self, mode = ""):
        self.board = [ [Cell(n) for n in random_sample(m, NUM_CELLS)] for m in range(1, 76, 15) ]
        self.board[2][2].marked = True
        self.desc_diagonal = [self.board[i][i] for i in range(0, NUM_CELLS)]
        self.asc_diagonal = [self.board[i][4-i] for i in range(0, NUM_CELLS)]

        self.win = False
        self.win_type = ""
        self.mode = mode 

    def print_board(self):
        print (FORMAT_STR % ("B", "I", "N", "G", "O"))
        for row in map(list, zip(*self.board)):
            print(FORMAT_STR % tuple(row))

        print()

    def is_match(self, ball):
        for row in self.board:
            for cell in row:
                cell.is_match(ball)

    def check_full(self):
        flat_board = [cell for row in self.board for cell in row]
        for cell in flat_board:
            if not self.win:
                self.win = all(cell.marked for cell in flat_board)
                self.win_type = "full"

    
    def check_horizontal(self):
        for row in map(list, zip(*self.board)):
            if not self.win:
                self.win = all(cell.marked for cell in row)
                self.win_type = "horizontal"

    def check_vertical(self):
        for row in self.board:
             if not self.win:
                self.win = all(cell.marked for cell in row)
                self.win_type = "vertical"

    def check_asc_diagonal(self):
        for cell in self.asc_diagonal:
            if not self.win:
                self.win = all(cell.marked for cell in self.asc_diagonal)
                self.win_type = "asc diagonal"

    def check_desc_diagonal(self):
        for cell in self.desc_diagonal:
            if not self.win:
                self.win = all(cell.marked for cell in self.desc_diagonal)
                win_type = "desc diagonal"

    def play(self, ball):
        current_ball = int(ball)
        print("Number: %s" % current_ball)

        self.is_match(current_ball)

        self.print_board()

        if self.mode == "full":
            self.check_full()
        else:
            self.check_asc_diagonal()
            self.check_desc_diagonal()
            self.check_horizontal()
            self.check_vertical()

if __name__ == "__main__":
    b = Board("full")
    while not b.win:
        b.play(randint(1, 76))