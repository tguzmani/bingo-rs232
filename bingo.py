import time
from cell import Cell
from utils import random_sample

NUM_CELLS = 5
FORMAT_STR = "%-4s " * 5

board = [ [Cell(n) for n in random_sample(m, NUM_CELLS)] for m in range(1, 76, 15) ]
board[2][2].marked = True

desc_diagonal = [board[i][i] for i in range(0, NUM_CELLS)]
asc_diagonal = [board[i][4-i] for i in range(0, NUM_CELLS)]

play = True
win_type = ""
i = 1

while play:
    current_number = randint(1, 76)
    print("Number: %d" % current_number)

    # mark cell if matched
    for row in board:
        for cell in row:
            cell.is_match(current_number)

    # print board
    print (FORMAT_STR % ("B", "I", "N", "G", "O"))
    for row in map(list, zip(*board)):
        print(FORMAT_STR % tuple(row))

    print()

    # vertical win
    for row in board:
        if play:
            play = not all(cell.marked for cell in row)
            win_type = "vertical"

    # horizontal win
    for row in map(list, zip(*board)):
        if play:
            play = not all(cell.marked for cell in row)
            win_type = "horizontal"

    # ascending diagonal win
    for cell in asc_diagonal:
        if play:
            play = not all(cell.marked for cell in asc_diagonal)
            win_type = "asc diagonal"

    # descending diagonal win
    for cell in desc_diagonal:
        if play:
            play = not all(cell.marked for cell in desc_diagonal)
            win_type = "desc diagonal"

    i += 1