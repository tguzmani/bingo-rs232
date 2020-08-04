class Cell:
	def __init__(self, number):
		self.number = number
		self.marked = False

	def __repr__(self):
		if self.marked:
			return "x"
		return str(self.number)

	def is_match(self, number):
		self.marked = number == self.number or self.marked