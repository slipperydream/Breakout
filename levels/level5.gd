extends Level

func _ready():
	bricks = {
		 # 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5
		0:[8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8],
		1:[7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7],
		2:[6,0,6,6,6,6,6,6,6,6,6,6,6,6,0,6],
		3:[5,0,5,0,0,0,0,5,5,0,0,0,0,5,0,5],
		4:[4,0,4,0,0,0,0,4,4,0,0,0,0,4,0,4],	
		5:[3,0,3,3,3,3,3,3,3,3,3,3,3,3,0,3],
		6:[2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2],
		7:[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
	}



