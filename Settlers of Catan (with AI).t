setscreen ("graphics:1020,1000")
var c : int %used for assigning resources to the hexes
var x : int := 260 %initial position of the first hexagon in the board
var y : int := 105
var l : int := 100 %the length of the hexagon
var n : int := 0 %used for assigning number to the hexes
var pics : array 1 .. 37 of int
var colours : array 1 .. 19 of int := init (1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 5, 5, 5, 6) %array of resources
var numbers : array 1 .. 19, 1 .. 2 of int := init (1, 5, 3, 2, 6, 6, 11, 3, 16, 8, 18, 10, 19, 9, 17, 12, 14, 11, 9, 4, 4, 8, 2, 10, 5, 9, 8, 4, 13, 5, 15, 6, 12,
    3, 7, 11, 10, 0) %the numbers for each hex and their order: first order, second number
/* order of the hexagons
	    19
	17      18
    14      15      16
	12      13
    9       10      11
	7       8
    4       5       6
	2       3
	    1           */
var vertices : array 1 .. 54, 1 .. 4 of int % 3rd index: 1. red settlement 2. red city 3. blue settlement 4. blue city, 4th is either 1 or 0 for the harbors
var hexagons : array 1 .. 19, 1 .. 9 of int % 1) x 2) y 3) colour 4) number(dice) 5th index: 1. red settlement 2. red city 3. blue settlement 4. blue city 6) robber
var roads:array 1..72,1..5 of int % 1) x of beginning 2) y of beginiing 3) x of end 4) y of end 5) colour
var sides:array 1..72,1..4 of int %keeps track of the position of all the sides
var harbors:array 1..9 of int:=init(1,2,3,4,5,6,6,6,6) %grain, ore, brick, wood, sheep, anything
var players:array 1..2 of int:=init(64,79) %keeps track of the colour of the roads (red and blue)
var resources:array 1..5 of int:=init(19,19,19,19,19) % wood, sheep, wheet, brick, metal
var rs:array 1..5 of string:=init("wood","wool","grain","clay","ore") % wood, sheep, wheet, brick, metal
var p1_hand:array 1..18 of int:=init(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0) % wood, sheep, wheet, brick, metal, knight, victory point, monopoly, year of plenty, road building, harbours 1 to 6,largest_army, longest_road
var p2_hand:array 1..18 of int:=init(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0) % wood, sheep, wheet, brick, metal, knight, victory point, monopoly, year of plenty, road building, harbours 1 to 6,largest_army, longest_road
var victory_cards:array 1..27 of int:=init(1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,3,3,4,4,5,5,6,7) %14 knights, 5 victory cards, 2 monopoly, 2 year of plenty, 2 road building, largest army, longest road
var init_resources:array 1..5 of int:=init(0,0,0,0,0) %used for assigning resources to the players after they put their last settlement
var order:array 1..5 of int:=init(2,1,4,3,5) %the order of signifance of for the resources
var used:array 1..72 of boolean %used to keep track of the used roads for the longest road
var dice:array 1..2 of int:=init(4,4) %used for the dice
var army:array 1..2 of int:=init(-1,2) %person and number of knights
var long_road:array 1..2 of int:=init(-1,4) %person and number of roads
var ind, res, upp, upp2,hex_count, desert_flag,turn : int := 0 
var mousex, mousey, button : int
var road_up,build,road,p1_army_count,p2_army_count,p1_road_count,p2_road_count,r_count,s_count:int:=0 %r_count and s_count is used for initial placements, The rest is used for longest road and largest army
var p1_vp,p2_vp,resource,road_build,play_one,init_build,last_settlement:int:=0
var v_top:int:=1 %counter of development cards
var test_mode:boolean:=false %used for testing
var comp_c,comp_s,comp_r:int:=0 %keeps track of computer's roads, settlements, and cities

proc load_images %loads the pictures
    pics (1) := Pic.FileNew ("images/wood.bmp")
    pics (2) := Pic.FileNew ("images/sheep.bmp")
    pics (3) := Pic.FileNew ("images/wheet.bmp")
    pics (4) := Pic.FileNew ("images/brick.bmp")
    pics (5) := Pic.FileNew ("images/metal.bmp")
    pics (6) := Pic.FileNew ("images/desert.bmp")
    pics (7) := Pic.FileNew ("images/rubber.bmp")
    pics (8) := Pic.FileNew ("images/red_settlement.bmp")
    pics (9) := Pic.FileNew ("images/red_city.bmp")
    pics (10) := Pic.FileNew ("images/blue_settlement.bmp")
    pics (11) := Pic.FileNew ("images/blue_city.bmp")    
    pics (12) := Pic.FileNew ("images/magnifier.bmp")
    pics (13) := Pic.FileNew ("images/building_costs.bmp")  
    pics (14) := Pic.FileNew ("images/harbor_1.bmp")  
    pics (15) := Pic.FileNew ("images/harbor_2.bmp")  
    pics (16) := Pic.FileNew ("images/harbor_3.bmp")  
    pics (17) := Pic.FileNew ("images/harbor_4.bmp")  
    pics (18) := Pic.FileNew ("images/harbor_5.bmp")  
    pics (19) := Pic.FileNew ("images/harbor_6.bmp")     
    pics (20) := Pic.FileNew ("images/wood_card.bmp") 
    pics (21) := Pic.FileNew ("images/wool_card.bmp") 
    pics (22) := Pic.FileNew ("images/grain_card.bmp") 
    pics (23) := Pic.FileNew ("images/brick_card.bmp") 
    pics (24) := Pic.FileNew ("images/ore_card.bmp") 
    pics (25) := Pic.FileNew ("images/knight.bmp") 
    pics (26) := Pic.FileNew ("images/victory_point_1.bmp") 
    pics (27) := Pic.FileNew ("images/monopoly.bmp") 
    pics (28) := Pic.FileNew ("images/year_of_plenty.bmp") 
    pics (29) := Pic.FileNew ("images/road_building.bmp") 
    pics (30) := Pic.FileNew ("images/largest_army.bmp") 
    pics (31) := Pic.FileNew ("images/longest_road.bmp") 
    pics (32) := Pic.FileNew ("images/1.bmp") 
    pics (33) := Pic.FileNew ("images/2.bmp") 
    pics (34) := Pic.FileNew ("images/3.bmp") 
    pics (35) := Pic.FileNew ("images/4.bmp") 
    pics (36) := Pic.FileNew ("images/5.bmp") 
    pics (37) := Pic.FileNew ("images/6.bmp") 
end load_images

function find_colour (f : string) : int %assigns a resource to each hexagon
    if f = "i" then
	loop
	    ind := Rand.Int (1, 19)
	    exit when colours (ind) ~= 0
	end loop
	res := colours (ind)
	colours (ind) := 0
    else
	res := hexagons (hex_count, 3)
    end if
    result res
end find_colour

proc add_vertex (x_v, y_v : int, var upp : int,f:string) %keeps track of all the vertices in an array and adds the vertices
    var flag : int := 0
    for i : 1 .. upp
	if abs (vertices (i, 1) - x_v) < 5 and abs (vertices (i, 2) - y_v) < 5 then
	    flag := 1
	end if
    end for
    if flag = 0 then
	upp += 1
	vertices (upp, 1) := x_v
	vertices (upp, 2) := y_v
	if f="i" then
	    vertices(upp,3):=0
	    vertices(upp,4):=0
	end if
    end if
end add_vertex

proc add_side(x1,y1,x2,y2:int,var upp2:int) %keeps track of all the sides in an array and adds the sides
    var flag2:int:=0
    for i:1..upp2
	if (abs (sides (i, 1) - x1) < 5 and abs (sides (i, 2) - y1) < 5 and abs (sides (i, 3) - x2) < 5 and abs (sides (i, 4) - y2) < 5) or (abs (sides (i, 1) - x2) < 5 and abs (sides (i, 2) - y2) < 5 and abs (sides (i, 3) - x1) < 5 and abs (sides (i, 4) - y1) < 5) then 
	    flag2:=1
	end if
    end for
    if flag2=0 then
	upp2+=1
	sides(upp2,1):=x1
	sides(upp2,2):=y1
	sides(upp2,3):=x2
	sides(upp2,4):=y2
    end if
end add_side

proc find_number(f:string) %assigns the number to each hex
    for i : 1 .. 19
	if hexagons (numbers (i, 1), 3) ~= 6 then
	    %draws the number
	    Draw.FillOval (hexagons (numbers (i, 1), 1), hexagons (numbers (i, 1), 2), 25, 25, white)
	    Draw.Text (intstr (numbers (i - desert_flag, 2)), hexagons (numbers (i, 1), 1) - 7 * (numbers (i - desert_flag, 2) div 10 + 1), hexagons (numbers (i, 1), 2) - 7, Font.New ("arial:18"),
		9)
	    hexagons (numbers (i, 1), 4) := numbers (i - desert_flag, 2)
	    if f="i" then %in the initial phase assigns zero for robber of all resources except desert
		hexagons(numbers(i,1),9):=0
	    end if
	elsif hexagons (numbers (i, 1), 3) = 6 then %keeps track of the robber and the desert
	    desert_flag := 1
	    hexagons (numbers (i, 1), 4) := 0
	    if f="i" then
		Pic.Draw (pics (7), hexagons (numbers (i, 1), 1)+10, hexagons (numbers (i, 1), 2) - 44, picMerge)
		hexagons(numbers(i,1),9):=1
	    end if
	end if
	if f~="i" then
	     if hexagons(numbers(i,1),9)=1 then
		Pic.Draw (pics (7), hexagons (numbers (i, 1), 1)+10, hexagons (numbers (i, 1), 2) - 44, picMerge)
	     end if
	end if
    end for
end find_number

proc draw_hex (n_x, n_y, l, c : int,f:string) %draws a hexagon
    var last_x : int := n_x
    var last_y : int := n_y
    add_vertex (last_x, last_y, upp,f)
    var a : int := 0
    Pic.Draw (pics (c), n_x - l div 2, n_y, picMerge)
    for i : 1 .. 6 %draws a line and adds 60 degrees 
	Draw.ThickLine (last_x, last_y, floor (last_x + cosd (a) * l), floor (last_y + sind (a) * l), 15, black)
	add_side(last_x, last_y, floor (last_x + cosd (a) * l), floor (last_y + sind (a) * l),upp2)
	last_x := floor (last_x + cosd (a) * l)
	last_y := floor (last_y + sind (a) * l)
	add_vertex (last_x, last_y, upp,f)
	a += 60
    end for
end draw_hex

proc draw_board (f : string) %draws the board
    Draw.FillBox (0, 0, 1000, 1000, 54)
    
    if f="i" then %this is only for initialzing 
	for i:1..19 %sets all the buildings for all hexes to zero
	    hexagons(i,5):=0
	    hexagons(i,6):=0
	    hexagons(i,7):=0
	    hexagons(i,8):=0
	end for
	
	for i:1..72 %the colour for all the roads is zero
	    roads(i,5):=0
	end for
	
	var ind1,ind2,ind3:int
	for i:1..9 %shuffles the array of the harbours so they will be random
	    ind1:=Rand.Int(1,9)
	    ind2:=Rand.Int(1,9)
	    ind3:=harbors(ind1)
	    harbors(ind1):=harbors(ind2)
	    harbors(ind2):=ind3
	end for
	
	for i:1..25 %shuffles the development cards
	    ind1:=Rand.Int(1,25)
	    ind2:=Rand.Int(1,25)
	    ind3:=victory_cards(ind1)
	    victory_cards(ind1):=victory_cards(ind2)
	    victory_cards(ind2):=ind3
	end for
    end if
    
    Pic.Draw (pics (harbors(1)+13),x, y-100, picMerge) %draws all the pictures of the harbors
    Pic.Draw (pics (harbors(2)+13),x+3*l+20, y-100, picMerge)
    Pic.Draw (pics (harbors(3)+13),x-3*l div 2, y+640, picMerge)
    Pic.Draw (pics (harbors(4)+13),x+5*l div 2+50, y+720, picMerge)
    Pic.Draw (pics (harbors(5)+13),-10, 330, picMerge)
    Pic.Draw (pics (harbors(6)+13),-10, 520, picMerge)
    Pic.Draw (pics (harbors(7)+13),x+6*l+10, 320, picMerge)
    Pic.Draw (pics (harbors(8)+13),x+6*l+10, 500, picMerge)
    Pic.Draw (pics (harbors(9)+13),x, y+710, picMerge)
    
    %draws the hexagons draws the bottom one first : 1
    upp := 0
    desert_flag := 0
    var y2 : int := y
    hex_count := 1
    c := find_colour (f)
    hexagons (1, 1) := x + 2 * l
    hexagons (1, 2) := y
    hexagons (1, 3) := c
    draw_hex (x + 3 * l div 2, y - floor (sqrt (3) * l / 2), l, c,f)
    hex_count += 1
/* order of the hexagons
	17      18
	12      13
	7       8
	2       3       */
    for i : 1 .. 4 %draws the middle column first
	c := find_colour (f)
	hexagons (hex_count, 1) := x + l div 2
	hexagons (hex_count, 2) := y2 + floor (sqrt (3) * l) div 2
	hexagons (hex_count, 3) := c
	draw_hex (x, y2, l, c,f)
	hex_count += 1
	c := find_colour (f)
	hexagons (hex_count, 1) := x + 7 * l div 2
	hexagons (hex_count, 2) := y2 + floor (sqrt (3) * l) div 2
	hexagons (hex_count, 3) := c
	draw_hex (x + 3 * l, y2, l, c,f)
	hex_count += 4
	y2 += floor (sqrt (3) * l)
    end for
    hex_count := 4
    y2 := y + floor (sqrt (3) * l / 2)
/* order of the hexagons
    14      15      16
    9       10      11
    4       5       6       */
    for i : 1 .. 3 %then it draws the wider column 
	c := find_colour (f)
	hexagons (hex_count, 1) := x - l
	hexagons (hex_count, 2) := y2 + floor (sqrt (3) * l) div 2
	hexagons (hex_count, 3) := c
	draw_hex (x - 3 * l div 2, y2, l, c,f)
	hex_count += 1
	c := find_colour (f)
	hexagons (hex_count, 1) := x + 2 * l
	hexagons (hex_count, 2) := y2 + floor (sqrt (3) * l) div 2
	hexagons (hex_count, 3) := c
	draw_hex (x + 3 * l div 2, y2, l, c,f)
	hex_count += 1
	c := find_colour (f)
	hexagons (hex_count, 1) := x + 5 * l
	hexagons (hex_count, 2) := y2 + floor (sqrt (3) * l) div 2
	hexagons (hex_count, 3) := c
	draw_hex (x + 9 * l div 2, y2, l, c,f)
	hex_count += 3
	y2 += floor (sqrt (3) * l)
    end for
    c := find_colour (f) %then draws the last hexagons: 19
    hexagons (19, 1) := x + 2 * l
    hexagons (19, 2) := y2 + floor (sqrt (3) * l) div 2
    hexagons (19, 3) := c
    draw_hex (x + 3 * l div 2, y2, l, c,f)

    find_number(f)
    
    %draws lines that conncet all the harbors
    Draw.ThickLine(vertices(6,1),vertices(6,2),x+40,y-40,12,66)
    Draw.ThickLine(vertices(7,1),vertices(7,2),x+40,y-40,12,66)    
    Draw.ThickLine(vertices(3,1),vertices(3,2),x+3*l+60,y-40,12,66)
    Draw.ThickLine(vertices(11,1),vertices(11,2),x+3*l+60,y-40,12,66)
    Draw.ThickLine(vertices(49,1),vertices(49,2),x-3*l div 2+40,y+650,12,66)
    Draw.ThickLine(vertices(34,1),vertices(34,2),x-3*l div 2+40,y+650,12,66)    
    Draw.ThickLine(vertices(54,1),vertices(54,2),x-3*l div 2+220,y+750,12,66)
    Draw.ThickLine(vertices(32,1),vertices(32,2),x-3*l div 2+220,y+750,12,66)  
    Draw.ThickLine(vertices(36,1),vertices(36,2),x-3*l div 2+500,y+720,12,66)
    Draw.ThickLine(vertices(37,1),vertices(37,2),x-3*l div 2+500,y+720,12,66) 
    Draw.ThickLine(vertices(51,1),vertices(51,2),x-3*l div 2+757,y+450,12,66)
    Draw.ThickLine(vertices(48,1),vertices(48,2),x-3*l div 2+757,y+450,12,66)
    Draw.ThickLine(vertices(43,1),vertices(43,2),x-3*l div 2+757,y+250,12,66)
    Draw.ThickLine(vertices(44,1),vertices(44,2),x-3*l div 2+757,y+250,12,66)
    Draw.ThickLine(vertices(40,1),vertices(40,2),x-3*l div 2-40,y+250,12,66)
    Draw.ThickLine(vertices(41,1),vertices(41,2),x-3*l div 2-40,y+250,12,66)
    Draw.ThickLine(vertices(50,1),vertices(50,2),x-3*l div 2-40,y+450,12,66)
    Draw.ThickLine(vertices(45,1),vertices(45,2),x-3*l div 2-40,y+450,12,66)
    
    %adds the harbors to the vertices that have a harbor on them
    vertices(6,4):=harbors(1)
    vertices(7,4):=harbors(1)
    vertices(3,4):=harbors(2)
    vertices(11,4):=harbors(2)
    vertices(49,4):=harbors(3)
    vertices(34,4):=harbors(3)
    vertices(36,4):=harbors(4)
    vertices(37,4):=harbors(4)
    vertices(40,4):=harbors(5)
    vertices(41,4):=harbors(5)
    vertices(45,4):=harbors(6)
    vertices(50,4):=harbors(6)
    vertices(44,4):=harbors(7)
    vertices(43,4):=harbors(7)
    vertices(48,4):=harbors(8)
    vertices(51,4):=harbors(8)
    vertices(32,4):=harbors(9)
    vertices(54,4):=harbors(9)

    
    for i : 1 .. upp %draws the vertices
	Draw.FillOval (vertices (i, 1), vertices (i, 2), 15, 15, 27)
    end for
    %draws the texts on the screen
    Draw.Text ("Next Turn", 800,900, Font.New ("arial:18"),yellow)
    Draw.Text ("Player 1's Victory Points: "+intstr(p1_vp), 10,950, Font.New ("arial:18"),yellow)
    Draw.Text ("Player 2's Victory Points: "+intstr(p2_vp), 700,950, Font.New ("arial:18"),yellow)
    Draw.Text ("Player " + intstr(turn mod 2+1)+"' s turn", 400,950, Font.New ("arial:18"),yellow)
    Pic.Draw (pics (12),100, 835, picMerge)
end draw_board

function vertex_find(x,y:int):int %finds the index of a vertex for a given x and y
    for i:1..54
	if x=vertices(i,1) and y=vertices(i,2) then
	    result i
	end if
    end for
end vertex_find

function exists(n:int,var check:array 1..* of int):boolean %checks to see if a number exists in an array
    for i:1..upper(check)
	if check(i)=n then
	    result true
	end if
    end for
    result false
end exists

proc display_board %display the board
    draw_board("d") %draws the board in a display mode not initialized mode
    
    if turn>2 then %shows the pictures of the dice
	Pic.Draw (pics (31+dice(1)),746, 775, picMerge)
	Pic.Draw (pics (31+dice(2)),872, 775, picMerge)
    end if
    
    for i:1..54 %draws all the settlements and all the cities
	if vertices(i,3)=1 then
	    Pic.Draw (pics (8),vertices (i, 1)-20, vertices (i, 2)-20, picMerge)
	elsif vertices(i,3)=2 then
	    Pic.Draw (pics (9),vertices (i, 1)-20, vertices (i, 2)-20, picMerge)
	elsif vertices(i,3)=3 then
	    Pic.Draw (pics (10),vertices (i, 1)-20, vertices (i, 2)-20, picMerge)
	elsif vertices(i,3)=4 then
	    Pic.Draw (pics (11),vertices (i, 1)-20, vertices (i, 2)-20, picMerge)
	end if    
    end for

    for i:1..road_up %draws all the roads
       Draw.ThickLine (roads (i, 1)+30*(roads(i,3)-roads(i,1)) div l, roads (i, 2)+30*(roads(i,4)-roads(i,2)) div l, roads (i, 3)+30*(roads(i,1)-roads(i,3)) div l, roads (i, 4)+30*(roads(i,2)-roads(i,4)) div l, 15, roads(i,5))
    end for
end display_board

function longest_road(n1,r:int):int %finds the length of a road for a given node
    var n2:int:=0
    if roads(r,1)=vertices(n1,1) and roads(r,2)=vertices(n1,2) then
	n2:=vertex_find(roads(r,3),roads(r,4))  
    elsif roads(r,3)=vertices(n1,1) and roads(r,4)=vertices(n1,2) then
	n2:=vertex_find(roads(r,1),roads(r,2)) 
    end if    
    var current,best:int:=0
    for i:1..72
	if roads(i,5)=players(turn mod 2 +1) and used(i)=false and (vertices(n1,3)=0 or vertices(n1,3) div 3= turn mod 2) and (vertex_find(roads(i,1),roads(i,2))=n2 or vertex_find(roads(i,3),roads(i,4))=n2) then
	    used(i):=true
	    current:=1+longest_road(n2,i)
	    if current>best then
		best:=current
	    end if
	end if
    end for
    used(r):=false
    result best
end longest_road

proc max_road %goes over all the roads to find the longest road
    for i:1..72
	used(i):=false
    end for
    
    var current:int:=0
    for i:1..72
	if roads(i,5)=players(turn mod 2 +1) and used(i)=false then
	    current:=longest_road(vertex_find(roads(i,1),roads(i,2)),i)
	    if current>p1_road_count and turn mod 2=0 then
		p1_road_count:=current
	    elsif current>p2_road_count and turn mod 2=1 then
		p2_road_count:=current
	    end if
	    current:=longest_road(vertex_find(roads(i,3),roads(i,4)),i)
	    if current>p1_road_count and turn mod 2=0 then
		p1_road_count:=current
	    elsif current>p2_road_count and turn mod 2=1 then
		p2_road_count:=current
	    end if
	end if
    end for
    %finds punt which player has the longest road and gives them victory points
    if p1_road_count>long_road(2) and turn mod 2=0 then
	p1_hand(18):=1
	if long_road(1)~=turn mod 2 then
	    if long_road(1)>=0 then
		p2_hand(18):=0
		p2_vp-=2
	    end if
	    p1_vp+=2
	    long_road(1):=turn mod 2
	    long_road(2):=p1_road_count
	end if
    elsif p2_road_count>long_road(2) and turn mod 2=1 then 
	p2_hand(18):=1
	if long_road(1)~=turn mod 2 then
	    Draw.FillBox(0,0,1000,1000,28)
	    Draw.Text ("Computer got the longest road", 50,540, Font.New ("arial:18"),black)
	    delay(1000)
	    display_board
	    if long_road(1)>=0 then
		p1_hand(18):=0
		p1_vp-=2
	    end if
	    p2_vp+=2
	    long_road(1):=turn mod 2
	    long_road(2):=p2_road_count
	end if
    end if
end max_road

function vertex_valid (x1,y1,turn:int):boolean %checks to see if a settlement can be placed on a point
    if turn<=2 then
	for i:1..54
	     if sqrt ((vertices (i, 1) - x1) ** 2 + (vertices (i, 2) - y1) ** 2) <= l+10 and vertices(i,3)~=0 then
		 result false
	     end if
	end for
	result true
    else
	for i:1..54
	     if sqrt ((vertices (i, 1) - x1) ** 2 + (vertices (i, 2) - y1) ** 2) <= l+10 and vertices(i,3)~=0 then
		 result false
	     end if
	end for

	for i:1..road_up
	    if (x1=roads(i,1) and y1=roads(i,2) and roads(i,5)=players(turn mod 2+1)) or (x1=roads(i,3) and y1=roads(i,4) and roads(i,5)=players(turn mod 2+1)) then
		result true
	    end if
	end for  
	result false
    end if
end vertex_valid

function check_vertex (x, y : int,var f:int,h:int) : boolean %puts down a settlement
    %checks if they can pay for it
    if (f=1 and p1_hand(1)>=1 and p1_hand(2)>=1 and p1_hand(3)>=1 and p1_hand(4)>=1) or (f=2 and p1_hand(3)>=2 and p1_hand(5)>=3) or (f=3 and p2_hand(1)>=1 and p2_hand(2)>=1 and p2_hand(3)>=1 and p2_hand(4)>=1) or (f=4 and p2_hand(3)>=2 and p2_hand(5)>=3) or turn<=2 then
	for i : 1 .. 54
	    if abs (vertices (i, 1) - x) <= 20 and abs (vertices (i, 2) - y) <= 20 then %finds the vertex based on distance
		if vertex_valid(vertices(i,1),vertices(i,2),turn)=true or f=2 or f=4 then
		    if turn<=2 then
			s_count+=1
		    end if
		    last_settlement:=i
		    init_build+=1
		    if f=1 then 
			if h=1 then %red settlement
			    Pic.Draw (pics (8),vertices (i, 1)-20, vertices (i, 2)-20, picMerge)
			    if turn>2 then
				p1_hand(1)-=1 %takes resources from the players
				p1_hand(2)-=1
				p1_hand(3)-=1
				p1_hand(4)-=1
				resources(1)+=1
				resources(2)+=1
				resources(3)+=1
				resources(4)+=1
			    end if
			    p1_vp+=1
			end if
		    elsif f=2 and vertices(i,3)=1 then %red city: for the cities it makes sure there is a settlement already there
			if h=1 then
			    Draw.Oval(vertices(i,1),vertices(i,2),15,15,27)
			    Pic.Draw (pics (9),vertices (i, 1)-20, vertices (i, 2)-20, picMerge)
			    if turn>2 then
				p1_hand(3)-=2 %takes resources from the players
				p1_hand(5)-=3
				resources(3)+=2
				resources(5)+=3
			    end if
			    p1_vp+=1
			end if
		    elsif f=3 then %blue settlement
			if h=1 then
			    Pic.Draw (pics (10),vertices (i, 1)-20, vertices (i, 2)-20, picMerge)
			    if turn>2 then
				p2_hand(1)-=1 %takes resources from the players
				p2_hand(2)-=1
				p2_hand(3)-=1
				p2_hand(4)-=1
				resources(1)+=1
				resources(2)+=1
				resources(3)+=1
				resources(4)+=1
			    end if
			    p2_vp+=1
			end if
		    elsif f=4 and vertices(i,3)=3 then %blue city: for the cities it makes sure there is a settlement already there
			if h=1 then
			    Draw.Oval(vertices(i,1),vertices(i,2),15,15,27)
			    Pic.Draw (pics (11),vertices (i, 1)-20, vertices (i, 2)-20, picMerge)
			    if turn>2 then
				p2_hand(3)-=2 %takes resources from the players
				p2_hand(5)-=3
				resources(3)+=2
				resources(5)+=3
			    end if
			    p2_vp+=1
		       end if
		    else
			result false
		    end if
		    if h=1 then
			vertices(i,3):=f
			if vertices(i,4)~=0 then
			    if turn mod 2=0 then
				p1_hand(10+vertices(i,4)):=1
			    else
				p2_hand(10+vertices(i,4)):=1
			    end if
			end if
			for j:1..19 %finds put which hexagons are connceted to that vertex
			    if sqrt ((vertices (i, 1) - hexagons (j, 1)) ** 2 + (vertices (i, 2) - hexagons (j, 2)) ** 2) <= floor(l*sqrt(3))+5 then 
				hexagons(j,4+f)+=1
				if (init_build=1 and turn=2) or (init_build=2 and turn=1) and hexagons(j,3)<=5 then
				    init_resources(hexagons(j,3))+=1
				end if   
			    end if
			end for
		    end if
		    result true
		end if
	    end if
	end for
    end if
    result false
end check_vertex

function road_valid(x1,x2,y1,y2,turn,road_up:int):boolean %it checks to see if a road can be placed there
    var v1,v2:int
    if turn<=2 then
	if last_settlement=0 then
	    result false
	end if
	if (x1=vertices(last_settlement,1) and y1=vertices(last_settlement,2)) or (x2=vertices(last_settlement,1) and y2=vertices(last_settlement,2)) then
	    last_settlement:=0
	    result true
	end if
	result false
    end if
    for i:1..road_up
	if x1=roads(i,1) and y1=roads(i,2) and x2=roads(i,3) and y2=roads(i,4) then
	    result false
	end if
    end for
    
    for i:1..54
	if x1=vertices(i,1) and y1=vertices(i,2) then
	    v1:=i
	elsif x2=vertices(i,1) and y2=vertices(i,2) then
	    v2:=i
	end if
    end for

    
    for i:1..road_up
	if (x1=roads(i,1) and y1=roads(i,2) and roads(i,5)=players(turn mod 2+1)) or (x1=roads(i,3) and y1=roads(i,4) and roads(i,5)=players(turn mod 2+1)) or (x2=roads(i,1) and y2=roads(i,2) and roads(i,5)=players(turn mod 2+1)) or(x2=roads(i,3) and y2=roads(i,4) and roads(i,5)=players(turn mod 2+1)) then
	    if ((x1=roads(i,1) and y1=roads(i,2)) or (x1=roads(i,3) and y1=roads(i,4))) and vertices(v1,3)~=0 and turn mod 2~=vertices(v1,3) div 3 and vertices(v2,3)=0 then
		result false
	    elsif ((x2=roads(i,1) and y2=roads(i,2)) or (x2=roads(i,3) and y2=roads(i,4))) and vertices(v2,3)~=0 and turn mod 2~=vertices(v2,3) div 3 and vertices(v1,3)=0 then
		result false
	    end if
	    result true
	end if
    end for
    
    for i:1..54
	if vertices(i,3)~=0 and ((x1=vertices(i,1) and y1=vertices(i,2) and turn mod 2=vertices(i,3) div 3) or (x2=vertices(i,1) and y2=vertices(i,2)and turn mod 2=vertices(i,3) div 3)) then
	    result true
	end if
    end for
    result false
end road_valid

function check_side (x, y : int,var road_up,f:int,h:int) : boolean
    %checks to see if there are enough resources for a road to be built
    if (turn mod 2=0 and p1_hand(1)>=1 and p1_hand(4)>=1) or (turn mod 2=1 and p2_hand(1)>=1 and p2_hand(4)>=1) or road_build>0 or turn<=2 then
	for i : 1 .. 53
	    for j : i+1 .. 54
		if sqrt ((vertices (i, 1) - x) ** 2 + (vertices (i, 2) - y) ** 2) <= l+2 and sqrt ((vertices (j, 1) - x) ** 2 + (vertices (j, 2) - y) ** 2) <= l+2 then
		    if road_valid(vertices (i, 1),vertices (j, 1),vertices (i, 2),vertices (j, 2),turn,road_up)=true then
			if turn<=2 then
			    r_count+=1
			end if
			if h=1 then %draws a road based on player and cost
			    Draw.ThickLine (vertices (i, 1)+30*(vertices(j,1)-vertices(i,1)) div l, vertices (i, 2)+30*(vertices(j,2)-vertices(i,2)) div l, vertices (j, 1)+30*(vertices(i,1)-vertices(j,1)) div l, vertices (j, 2)+30*(vertices(i,2)-vertices(j,2)) div l, 15, players(turn mod 2 +1))
			    road_up+=1
			    roads(road_up,1):=vertices (i, 1)
			    roads(road_up,2):=vertices (i, 2)
			    roads(road_up,3):=vertices (j, 1)
			    roads(road_up,4):=vertices (j, 2)
			    roads(road_up,5):=players(turn mod 2 +1)
			    if turn mod 2=0 and road_build=0 and turn>2 then
				p1_hand(1)-=1 %players pay based on resources
				p1_hand(4)-=1 
				resources(1)+=1
				resources(4)+=1   
			    elsif turn mod 2=1 and road_build=0 and turn>2 then
				p2_hand(1)-=1 %players pay based on resources
				p2_hand(4)-=1
				resources(1)+=1
				resources(4)+=1 
			    end if
			    if road_build>0 then
				road_build-=1
			    end if
			    max_road
			end if
			result true
		    end if
		end if
	    end for
	end for
    end if
    result false
end check_side

proc largest_army %counts the number of army cards plays
    if turn mod 2=0 then
	p1_army_count+=1
	p1_hand(6)-=1
    else
	p2_army_count+=1
	p2_hand(6)-=1
	Draw.FillBox(0,0,1000,1000,28)
	Draw.Text ("Army Card was played", 50,540, Font.New ("arial:18"),black) %tells the other player that he played an army card
	delay(1000)
    end if
    if p1_army_count>army(2) and turn mod 2=0 then %finds who has the largest army
	p1_hand(17):=1
	if army(1)~=turn mod 2 then
	    if army(1)>=0 then
		p2_hand(17):=0
		p2_vp-=2
	    end if
	    p1_vp+=2
	    army(1):=turn mod 2
	    army(2):=p1_army_count
	end if
    elsif p2_army_count>army(2) and turn mod 2=1 then
	p2_hand(17):=1
	if army(1)~=turn mod 2 then
	    Draw.FillBox(0,0,1000,1000,28)
	    Draw.Text ("Computer got the largest army", 50,540, Font.New ("arial:18"),black)
	    delay(1000)
	    if army(1)>=0 then
		p1_hand(17):=0
		p1_vp-=2
	    end if
	    p2_vp+=2
	    army(1):=turn mod 2
	    army(2):=p2_army_count
	end if
    end if
    delay(300)
end largest_army

proc monopoly
    %checks to see if the other player has enough resources for monopoly to be played
    if (turn mod 2=0 and (p2_hand(1)>0 or p2_hand(2)>0 or p2_hand(3)>0 or p2_hand(4)>0 or p2_hand(5)>0)) or (turn mod 2=1 and (p1_hand(1)>0 or p1_hand(2)>0 or p1_hand(3)>0 or p1_hand(4)>0 or p1_hand(5)>0)) then
	Draw.FillBox(0,0,1000,1000,28)
	play_one:=1
	if turn mod 2=0 then
	    p1_hand(8)-=1
	else
	    p2_hand(8)-=1
	end if
	if turn mod 2=0 then
	    var x_c:int:=460
	    var y_c:int:=820
	    Draw.Text ("Pick one of your opponent's resources and take all of the resources for that card", 50,940, Font.New ("arial:18"),black)
	    for i:1..5
		if turn mod 2=0 and p2_hand(i)>0  then
		    Pic.Draw (pics (19+i),x_c,y_c, picMerge)
		    Draw.Text ("* "+intstr(p2_hand(i)), x_c+100,y_c, Font.New ("arial:18"),black) 
		elsif turn mod 2=1 and p1_hand(i)>0  then
		    Pic.Draw (pics (19+i),x_c,y_c, picMerge)
		    Draw.Text ("* "+intstr(p1_hand(i)), x_c+100,y_c, Font.New ("arial:18"),black) 
		end if
		y_c-=180
	    end for 
	    y_c:=820
	    button:=0
	    resource:=0
	    loop
		Mouse.Where(mousex,mousey,button) %waits for the player to pick a resource
		if button=1 then
		    if mousex>=x_c and mousex<=x_c+70 and mousey>=y_c and mousey<=y_c+80 and ((turn mod 2=0 and p2_hand(1)>0)or(turn mod 2=1 and p1_hand(1)>0))  then
			resource:=1
			exit
		    elsif mousex>=x_c and mousex<=x_c+70 and mousey>=y_c-180 and mousey<=y_c-100  and ((turn mod 2=0 and p2_hand(2)>0)or(turn mod 2=1 and p1_hand(2)>0)) then
			resource:=2
			exit
		    elsif mousex>=x_c and mousex<=x_c+70 and mousey>=y_c-360 and mousey<=y_c-280  and ((turn mod 2=0 and p2_hand(3)>0)or(turn mod 2=1 and p1_hand(3)>0))then
			resource:=3
			exit
		    elsif mousex>=x_c and mousex<=x_c+70 and mousey>=y_c-540 and mousey<=y_c-460  and ((turn mod 2=0 and p2_hand(4)>0)or(turn mod 2=1 and p1_hand(4)>0))then
			resource:=4
			exit
		    elsif mousex>=x_c and mousex<=x_c+70 and mousey>=y_c-720 and mousey<=y_c-640  and ((turn mod 2=0 and p2_hand(5)>0)or(turn mod 2=1 and p1_hand(5)>0))then
			resource:=5
			exit
		    end if
		end if
	    end loop
	elsif turn mod 2=1 then
	    Draw.Text ("The monopoly card was chosen", 50,540, Font.New ("arial:18"),black) 
	    loop %the computer picks a random resource for monopoly
		resource:=Rand.Int(1,5)
		exit when p1_hand(resource)>0
	    end loop
	    Draw.Text ("Computer got all the "+rs(resource)+" cards", 50,500, Font.New ("arial:18"),black) 
	    delay(1000) 
	end if
	if turn mod 2=0 then
	    p1_hand(resource)+=p2_hand(resource)
	    p2_hand(resource):=0
	else
	    p2_hand(resource)+=p1_hand(resource)
	    p1_hand(resource):=0
	end if
    end if
end monopoly

proc year_of_plenty 
    Draw.FillBox(0,0,1000,1000,28)
    play_one:=1
    if turn mod 2=0 then
	p1_hand(9)-=1
    else
	p2_hand(9)-=1
    end if
    if turn mod 2=0 then %checks to see if the computer 
	var x_c:int:=460
	var y_c:int:=820
	for i:1..5
	    Pic.Draw (pics (19+i),x_c,y_c, picMerge)
	    y_c-=180
	end for
	Draw.Text ("Pick a resource and recieve two cards for it", 250,940, Font.New ("arial:18"),black)
	y_c:=820
	button:=0
	resource:=0
	loop
	    Mouse.Where(mousex,mousey,button)
	    if button=1 then
		if mousex>=x_c and mousex<=x_c+70 and mousey>=y_c and mousey<=y_c+80 then
		    resource:=1
		    exit
		elsif mousex>=x_c and mousex<=x_c+70 and mousey>=y_c-180 and mousey<=y_c-100 then
		    resource:=2
		    exit
		elsif mousex>=x_c and mousex<=x_c+70 and mousey>=y_c-360 and mousey<=y_c-280 then
		    resource:=3
		    exit
		elsif mousex>=x_c and mousex<=x_c+70 and mousey>=y_c-540 and mousey<=y_c-460 then
		    resource:=4
		    exit
		elsif mousex>=x_c and mousex<=x_c+70 and mousey>=y_c-720 and mousey<=y_c-640 then
		    resource:=5
		    exit
		end if
	    end if
	end loop
    else
	Draw.Text ("Year of Plenty Card was selected", 50,540, Font.New ("arial:18"),black)  %computer gets two neww resources at random
	resource:=Rand.Int(1,5)
	Draw.Text ("Computer got 2 new "+rs(resource)+" cards", 50,500, Font.New ("arial:18"),black)
	delay(1000) 
    end if
    if turn mod 2=0 then
	p1_hand(resource)+=2
	resources(resource)-=2
    else
	p2_hand(resource)+=2
	resources(resource)-=2
    end if
end year_of_plenty

proc road_building
    var possible_road_count:int:=0
    for i:1..upper(sides)
	if road_valid(sides (i, 1),sides (i, 3),sides (i, 2),sides (i, 4),turn,road_up)=true then
	    possible_road_count+=1
	end if
    end for
    if possible_road_count>=2 then %it makes sure the player can build two new roads
	play_one:=1
	if turn mod 2=0 then
	    p1_hand(10)-=1
	else
	    p2_hand(10)-=1
	end if
	display_board
	button:=0
	road_build:=2
	if turn mod 2=0 then
	    loop
		Mouse.Where(mousex,mousey,button)
		if button=1 then
		    if View.WhatDotColour (mousex, mousey) = 7 then
			if check_side (mousex, mousey, road_up,road,1) = true then
			    %side selected
			end if
		    end if
		    delay(500)
		end if
		exit when road_build=0
	    end loop
       else
	    Draw.FillBox(0,0,1000,1000,28)
	    Draw.Text ("Road Building Card was played", 50,540, Font.New ("arial:18"),black)%tells the player that road building card was played
	    delay(1000)
	    var check4:flexible array 1..0 of int
	    road:=1
	    var rnd:int
	    loop
		loop
		    rnd:=Rand.Int(1,upper(roads))
		    if exists(rnd,check4)=false then
			new check4,upper(check4)+1
			check4(upper(check4)):=rnd
			exit
		    end if
		    exit when upper(check4)=72
		end loop
		if roads(rnd,5)=0 then
		    if check_side ((sides(rnd,1)+sides(rnd,3)) div 2, (sides(rnd,2)+sides(rnd,4)) div 2, road_up,road,1) and comp_r<=comp_s+5 then
			comp_r+=1
		    end if
		end if
		exit when road_build=0
	    end loop
       end if
    end if
end road_building

proc victory   %gives a development card to each player
    if turn mod 2=0 then
	p1_hand(2)-=1
	p1_hand(3)-=1
	p1_hand(5)-=1
	resources(2)+=1
	resources(3)+=1
	resources(5)+=1
    else
	p2_hand(2)-=1
	p2_hand(3)-=1
	p2_hand(5)-=1
	resources(2)+=1
	resources(3)+=1
	resources(5)+=1
    end if
    
    var hand_index:int:=0
    if victory_cards(v_top)=1 then
	hand_index:=6
    elsif victory_cards(v_top)=2 then
	hand_index:=7
    elsif victory_cards(v_top)=3 then
	hand_index:=8
    elsif victory_cards(v_top)=4 then
	hand_index:=9
    elsif victory_cards(v_top)=5 then
	hand_index:=10
    end if
    
    if hand_index~=0 then %adds the victory card to the hand
	if turn mod 2=0 then
	    p1_hand(hand_index)+=1
	    if hand_index=7 then
		p1_vp+=1
	    end if
	else
	    p2_hand(hand_index)+=1
	    if hand_index=7 then
		p2_vp+=1
	    end if
	end if
    end if
    v_top+=1
    delay(500)
end victory

proc harbor (f:int) %manages the harbors: the player lose resources and gain resources based on their trades
    resource:=0
    button:=0
    if f=1 and ((turn mod 2=0 and p1_hand(3)>=2) or (turn mod 2=1 and p2_hand(3)>=2)) then %2 to 1 grain
	Draw.FillBox(0,0,1000,1000,28)
	if turn mod 2=0 then
	    p1_hand(3)-=2
	else
	    p2_hand(3)-=2
	    Draw.Text ("2 to 1 trade of grain was done", 50,520, Font.New ("arial:18"),black)
	end if
	resource:=3
    elsif f=2  and ((turn mod 2=0 and p1_hand(5)>=2) or (turn mod 2=1 and p2_hand(5)>=2)) then %2 to 1 ore
	Draw.FillBox(0,0,1000,1000,28)
	if turn mod 2=0 then
	    p1_hand(5)-=2
	else
	    p2_hand(5)-=2
	    Draw.Text ("2 to 1 trade of ore was done", 50,520, Font.New ("arial:18"),black)
	end if
	resource:=5    
    elsif f=3  and ((turn mod 2=0 and p1_hand(4)>=2) or (turn mod 2=1 and p2_hand(4)>=2)) then %2 to 1 clay
	Draw.FillBox(0,0,1000,1000,28)     
	if turn mod 2=0 then
	    p1_hand(4)-=2
	else
	    p2_hand(4)-=2
	    Draw.Text ("2 to 1 trade of clay was done", 50,520, Font.New ("arial:18"),black)
	end if
	resource:=4    
    elsif f=4  and ((turn mod 2=0 and p1_hand(1)>=2) or (turn mod 2=1 and p2_hand(1)>=2)) then %2 to 1 wood
	Draw.FillBox(0,0,1000,1000,28)
	if turn mod 2=0 then
	    p1_hand(1)-=2
	else
	    p2_hand(1)-=2
	    Draw.Text ("2 to 1 trade of wood was done", 50,520, Font.New ("arial:18"),black)
	end if
	resource:=1    
    elsif f=5  and ((turn mod 2=0 and p1_hand(2)>=2) or (turn mod 2=1 and p2_hand(2)>=2)) then %2 to 1 wool
	Draw.FillBox(0,0,1000,1000,28)
	if turn mod 2=0 then
	    p1_hand(2)-=2
	else
	    p2_hand(2)-=2
	    Draw.Text ("2 to 1 trade of wool was done", 50,520, Font.New ("arial:18"),black)
	end if
	resource:=2    
    elsif f=6  and ((turn mod 2=0 and (p1_hand(1)>=3 or p1_hand(2)>=3 or p1_hand(3)>=3 or p1_hand(4)>=3 or p1_hand(5)>=3)) or (turn mod 2=1 and (p2_hand(1)>=3 or p2_hand(2)>=3 or p2_hand(3)>=3 or p2_hand(4)>=3 or p2_hand(5)>=3))) then
	%3 to 1 trade    
	Draw.FillBox(0,0,1000,1000,28)    
	if turn mod 2=0 then
	    var x_c:int:=460
	    var y_c:int:=820
	    for i:1..5
		if (turn mod 2=0 and p1_hand(i)>=3) or (turn mod 2=1 and p2_hand(i)>=3) then
		    Pic.Draw (pics (19+i),x_c,y_c, picMerge)
		end if
		y_c-=180
	    end for
	    Draw.Text ("Pick a resource to take three cards from it", 250,940, Font.New ("arial:18"),black)
	    y_c:=820
	    loop
		Mouse.Where(mousex,mousey,button) %lets the player choose the card they want to give up
		if button=1 then
		    if mousex>=x_c and mousex<=x_c+70 and mousey>=y_c and mousey<=y_c+80 and ((turn mod 2=0 and p1_hand(1)>=3)or(turn mod 2=1 and p2_hand(1)>=3)) then
			resource:=1
			exit
		    elsif mousex>=x_c and mousex<=x_c+70 and mousey>=y_c-180 and mousey<=y_c-100  and ((turn mod 2=0 and p1_hand(2)>=3)or(turn mod 2=1 and p2_hand(2)>=3)) then
			resource:=2
			exit
		    elsif mousex>=x_c and mousex<=x_c+70 and mousey>=y_c-360 and mousey<=y_c-280  and ((turn mod 2=0 and p1_hand(3)>=3)or(turn mod 2=1 and p2_hand(3)>=3)) then
			resource:=3
			exit
		    elsif mousex>=x_c and mousex<=x_c+70 and mousey>=y_c-540 and mousey<=y_c-460  and ((turn mod 2=0 and p1_hand(4)>=3)or(turn mod 2=1 and p2_hand(4)>=3)) then
			resource:=4
			exit
		    elsif mousex>=x_c and mousex<=x_c+70 and mousey>=y_c-720 and mousey<=y_c-640  and ((turn mod 2=0 and p1_hand(5)>=3)or(turn mod 2=1 and p2_hand(5)>=3)) then
			resource:=5
			exit
		    end if
		end if
	    end loop 
	else
	    for i:1..5 %the computer only chooses that is least significance to give up
		if p2_hand(order(i))>=3 then
		    resource:=order(i)
		end if
	    end for
	    Draw.Text ("3 to 1 trade was done", 50,520, Font.New ("arial:18"),black)
	end if 
	if turn mod 2=0 then
	    p1_hand(resource)-=3
	else
	    p2_hand(resource)-=3
	end if
    elsif f=7  and ((turn mod 2=0 and (p1_hand(1)>=4 or p1_hand(2)>=4 or p1_hand(3)>=4 or p1_hand(4)>=4 or p1_hand(5)>=4)) or (turn mod 2=1 and (p2_hand(1)>=4 or p2_hand(2)>=4 or p2_hand(3)>=4 or p2_hand(4)>=4 or p2_hand(5)>=4))) then
	 %4 to 1 trade     
	 Draw.FillBox(0,0,1000,1000,28)    
	if turn mod 2=0 then    
	    var x_c:int:=460
	    var y_c:int:=820
	    for i:1..5
		if (turn mod 2=0 and p1_hand(i)>=4) or (turn mod 2=1 and p2_hand(i)>=4) then
		    Pic.Draw (pics (19+i),x_c,y_c, picMerge)
		end if
		y_c-=180
	    end for
	    Draw.Text ("Pick a resource to take four cards from it", 250,940, Font.New ("arial:18"),black)
	    y_c:=820
	    loop
		Mouse.Where(mousex,mousey,button) %lets the player choose the card they want to give up
		if button=1 then
		    if mousex>=x_c and mousex<=x_c+70 and mousey>=y_c and mousey<=y_c+80 and ((turn mod 2=0 and p1_hand(1)>=4)or(turn mod 2=1 and p2_hand(1)>=4)) then
			resource:=1
			exit
		    elsif mousex>=x_c and mousex<=x_c+70 and mousey>=y_c-180 and mousey<=y_c-100  and ((turn mod 2=0 and p1_hand(2)>=4)or(turn mod 2=1 and p2_hand(2)>=4)) then
			resource:=2
			exit
		    elsif mousex>=x_c and mousex<=x_c+70 and mousey>=y_c-360 and mousey<=y_c-280  and ((turn mod 2=0 and p1_hand(3)>=4)or(turn mod 2=1 and p2_hand(3)>=4)) then
			resource:=3
			exit
		    elsif mousex>=x_c and mousex<=x_c+70 and mousey>=y_c-540 and mousey<=y_c-460  and ((turn mod 2=0 and p1_hand(4)>=4)or(turn mod 2=1 and p2_hand(4)>=4)) then
			resource:=4
			exit
		    elsif mousex>=x_c and mousex<=x_c+70 and mousey>=y_c-720 and mousey<=y_c-640  and ((turn mod 2=0 and p1_hand(5)>=4)or(turn mod 2=1 and p2_hand(5)>=4)) then
			resource:=5
			exit
		    end if
		end if
	    end loop
	else
	    for i:1..5 %the computer only chooses that is least significance to give up
		if p2_hand(order(i))>=4 then
		    resource:=order(i)
		end if
	    end for
	    Draw.Text ("4 to 1 trade was done", 50,520, Font.New ("arial:18"),black)
	end if   
	if turn mod 2=0 then
	    p1_hand(resource)-=4
	else
	    p2_hand(resource)-=4
	end if    
    end if
    if resource~=0 and turn mod 2=0 then %the players get to choose the resource they want
	Draw.FillBox(0,0,1000,1000,28)
	var x_c:int:=460
	var y_c:int:=820
	for i:1..5
	    if i~=resource then
		Pic.Draw (pics (19+i),x_c,y_c, picMerge)
	    end if
	    y_c-=180
	end for
	Draw.Text ("Pick the resource that you want to recieve a card for", 250,940, Font.New ("arial:18"),black)
	y_c:=820
	button:=0
	loop
	    Mouse.Where(mousex,mousey,button)
	    if button=1 then
		if mousex>=x_c and mousex<=x_c+70 and mousey>=y_c and mousey<=y_c+80 and resource~=1 then
		    resource:=1
		    exit
		elsif mousex>=x_c and mousex<=x_c+70 and mousey>=y_c-180 and mousey<=y_c-100  and resource~=2 then
		    resource:=2
		    exit
		elsif mousex>=x_c and mousex<=x_c+70 and mousey>=y_c-360 and mousey<=y_c-280  and resource~=3 then
		    resource:=3
		    exit
		elsif mousex>=x_c and mousex<=x_c+70 and mousey>=y_c-540 and mousey<=y_c-460  and resource~=4 then
		    resource:=4
		    exit
		elsif mousex>=x_c and mousex<=x_c+70 and mousey>=y_c-720 and mousey<=y_c-640  and resource~=5 then
		    resource:=5
		    exit
		end if
	    end if
	end loop
	if turn mod 2=0 then
	    p1_hand(resource)+=1
	else
	    p2_hand(resource)+=1
	end if  
	resources(resource)-=1
    elsif resource~=0 and turn mod 2=1 then %the computer picks the resource that it needs based on its signficance 
	var chose:int:=0
	for decreasing i:5..1
	    if p2_hand(order(i))=0 and chose=0 then
		p2_hand(order(i))+=1
		chose:=i
	    end if
	end for
	Draw.Text ("Computer got a new "+rs(order(chose))+" card", 50,480, Font.New ("arial:18"),black)        
	delay(1000)
    end if
end harbor

proc interface_7 %when a 7 is rolled it checks to see if each player has more than seven cards or not and if they do they lose their cards
    button:=0
    var select_pos:flexible array 1..0,1..2 of int
    var player_copy:array 1..5 of int
    var select:int:=0
    var c_count:int:=0

    for i:1..5
	c_count+=p1_hand(i)
	player_copy(i):=p1_hand(i)
    end for
    if c_count>=7 then %if the player has more than seven cards they get to choose their cards and if they want to lose it or not
	cls
	Draw.FillBox (0, 0, 1000, 1000, 28)
	var x_p:int:=0
	var y_p:int:=920
	for i:1..5
	     Pic.Draw (pics (19+i),x_p,y_p, picMerge)
	     Draw.Text ("* "+intstr(p1_hand(i)), x_p+100,y_p+30, Font.New ("arial:14"),black) 
	     x_p:=0
	     y_p:=920-174*i
	end for
	Draw.Text ("Player One", 850,850, Font.New ("arial:14"),black) 
	Draw.Text ("Select " +intstr(c_count div 2)+" cards to be", 795,800, Font.New ("arial:14"),black)   
	Draw.Text ("removed from your hand", 795,750, Font.New ("arial:14"),black) 
	Draw.Text ("SELECT", 850,650, Font.New ("arial:14"),blue) 
	Draw.Text ("Selected:", 850,600, Font.New ("arial:14"),blue)
	Draw.Text (intstr(select), 900,550, Font.New ("arial:14"),blue)  
	loop %shows the number of cards for each resource and has the options of remove or add so the player can choose whether they want to remove or add that resource
	    if p1_hand(1)<player_copy(1) then
		Draw.Text ("add", x_p+200,950, Font.New ("arial:14"),black) 
	    end if  
	    if p1_hand(1)>0 then
		Draw.Text ("remove", x_p+300,950, Font.New ("arial:14"),black)
	    end if 
	    if p1_hand(2)<player_copy(2) then
		Draw.Text ("add", x_p+200,776, Font.New ("arial:14"),black)
	    end if 
	    if p1_hand(2)>0 then
		Draw.Text ("remove", x_p+300,776, Font.New ("arial:14"),black)
	    end if 
	    if p1_hand(3)<player_copy(3) then
		Draw.Text ("add", x_p+200,602, Font.New ("arial:14"),black)
	    end if 
	    if p1_hand(3)>0 then
		Draw.Text ("remove", x_p+300,602, Font.New ("arial:14"),black)
	    end if 
	    if p1_hand(4)<player_copy(4) then
		Draw.Text ("add", x_p+200,428, Font.New ("arial:14"),black)
	    end if 
	    if p1_hand(4)>0 then
		Draw.Text ("remove", x_p+300,428, Font.New ("arial:14"),black)
	    end if 
	    if p1_hand(5)<player_copy(5) then
		Draw.Text ("add", x_p+200,254, Font.New ("arial:14"),black)
	    end if 
	    if p1_hand(5)>0 then
		Draw.Text ("remove", x_p+300,254, Font.New ("arial:14"),black)
	    end if 
	    Mouse.Where(mousex,mousey,button)
	    if button=1 then
		if mousey>=950 and mousey<=980 then
		    if mousex>=x_p+200 and mousex<=x_p+250 and p1_hand(1)<player_copy(1)then %only lets them add resources if they do not exceed the original amount
			p1_hand(1)+=1
			select-=1
		    elsif mousex>=x_p+300 and mousex<=x_p+350 and p1_hand(1)>0 then %only lets them get rid of a resource until it does not become zero
			p1_hand(1)-=1
			select+=1
		    end if 
		    Draw.FillBox(x_p+100,950,x_p+150,980,28)
		    Draw.Text ("* "+intstr(p1_hand(1)), x_p+100,950, Font.New ("arial:14"),black)
		    Draw.FillBox(900,550,1000,600,28)
		    Draw.Text (intstr(select), 900,550, Font.New ("arial:14"),blue)  
		elsif mousey>=776 and mousey<=806 then
		    if mousex>=x_p+200 and mousex<=x_p+250 and p1_hand(2)<player_copy(2)then %only lets them add resources if they do not exceed the original amount
			p1_hand(2)+=1
			select-=1
		    elsif mousex>=x_p+300 and mousex<=x_p+350 and p1_hand(2)>0 then %only lets them get rid of a resource until it does not become zero
			p1_hand(2)-=1
			select+=1
		    end if 
		    Draw.FillBox(x_p+100,776,x_p+150,806,28)
		    Draw.Text ("* "+intstr(p1_hand(2)), x_p+100,776, Font.New ("arial:14"),black) 
		    Draw.FillBox(900,550,1000,600,28)
		    Draw.Text (intstr(select), 900,550, Font.New ("arial:14"),blue)  
		elsif mousey>=602 and mousey<=632 then
		    if mousex>=x_p+200 and mousex<=x_p+250 and p1_hand(3)<player_copy(3)then %only lets them add resources if they do not exceed the original amount
			p1_hand(3)+=1
			select-=1
		    elsif mousex>=x_p+300 and mousex<=x_p+350 and p1_hand(3)>0 then %only lets them get rid of a resource until it does not become zero
			p1_hand(3)-=1
			select+=1
		    end if 
		    Draw.FillBox(x_p+100,602,x_p+150,632,28)
		    Draw.Text ("* "+intstr(p1_hand(3)), x_p+100,602, Font.New ("arial:14"),black) 
		    Draw.FillBox(900,550,1000,600,28)
		    Draw.Text (intstr(select), 900,550, Font.New ("arial:14"),blue)  
		elsif mousey>=428 and mousey<=458 then
		    if mousex>=x_p+200 and mousex<=x_p+250 and p1_hand(4)<player_copy(4)then %only lets them add resources if they do not exceed the original amount
			p1_hand(4)+=1
			select-=1
		    elsif mousex>=x_p+300 and mousex<=x_p+350 and p1_hand(4)>0 then %only lets them get rid of a resource until it does not become zero
			p1_hand(4)-=1
			select+=1
		    end if 
		    Draw.FillBox(x_p+100,428,x_p+150,458,28)
		    Draw.Text ("* "+intstr(p1_hand(4)), x_p+100,428, Font.New ("arial:14"),black) 
		    Draw.FillBox(900,550,1000,600,28)
		    Draw.Text (intstr(select), 900,550, Font.New ("arial:14"),blue)  
		elsif mousey>=254 and mousey<=284 then
		    if mousex>=x_p+200 and mousex<=x_p+250 and p1_hand(5)<player_copy(5)then %only lets them add resources if they do not exceed the original amount
			p1_hand(5)+=1
			select-=1
		    elsif mousex>=x_p+300 and mousex<=x_p+350 and p1_hand(5)>0 then %only lets them get rid of a resource until it does not go past zero
			p1_hand(5)-=1
			select+=1
		    end if 
		    Draw.FillBox(x_p+100,254,x_p+150,284,28)
		    Draw.Text ("* "+intstr(p1_hand(5)), x_p+100,254, Font.New ("arial:14"),black) 
		    Draw.FillBox(900,550,1000,600,28)
		    Draw.Text (intstr(select), 900,550, Font.New ("arial:14"),blue)  
		elsif mousex>=850 and mousey>=650 and mousex<=950 and mousey<=800 then
		    if select=c_count div 2 then %only if they have the right amount of cards they can leave the menu
			exit
		    else %otherwise the resources are set to orignial
			for i:1..5
			    p1_hand(i):=player_copy(i)
			end for
			select:=0
			Draw.FillBox(x_p+100,950,x_p+150,980,28)
			Draw.Text ("* "+intstr(p1_hand(1)), x_p+100,950, Font.New ("arial:14"),black) 
			Draw.FillBox(x_p+100,776,x_p+150,806,28)
			Draw.Text ("* "+intstr(p1_hand(2)), x_p+100,776, Font.New ("arial:14"),black) 
			Draw.FillBox(x_p+100,602,x_p+150,632,28)
			Draw.Text ("* "+intstr(p1_hand(3)), x_p+100,602, Font.New ("arial:14"),black)
			Draw.FillBox(x_p+100,428,x_p+150,458,28)
			Draw.Text ("* "+intstr(p1_hand(4)), x_p+100,428, Font.New ("arial:14"),black) 
			Draw.FillBox(x_p+100,254,x_p+150,284,28)
			Draw.Text ("* "+intstr(p1_hand(5)), x_p+100,254, Font.New ("arial:14"),black)
			Draw.FillBox(900,550,1000,600,28)
			Draw.Text (intstr(select), 900,550, Font.New ("arial:14"),blue)   
		    end if
		end if  
		delay(500) 
	    end if
	end loop
    end if
    select:=0
    button:=0
    c_count:=0
    for i:1..5
	c_count+=p2_hand(i)
	player_copy(i):=p2_hand(i)
    end for
    if c_count>=7 then
	cls
	Draw.FillBox (0, 0, 1000, 1000, 28)
	Draw.Text ("Computer lost half of its cards", 50,520, Font.New ("arial:14"),black)
	var or_c:int:=1
	for i:1..c_count div 2 %the computer loses half of its card based on the order of significance
	    if p2_hand(order(or_c))>0 then
		p2_hand(order(or_c))-=1
	    else
		or_c+=1
		p2_hand(order(or_c))-=1
	    end if
	end for
	delay(1000) 
    end if  
end interface_7

proc robber %the function moves the robber
    button:=0
    display_board
    Draw.Text ("Move the robber", 800,740, Font.New ("arial:18"),yellow) 
    var hex_1,hex_2:int:=0
    for i:1..19
	if hexagons(i,9)=1 then
	    hex_1:=i
	end if
    end for
    if turn mod 2=0 then %if it's player's turn it asks the player to ask a location for a robber
	loop
	    Mouse.Where(mousex,mousey,button)
	    if button=1 then
		for i:1..19
		    if sqrt((mousex-hexagons(i,1))**2+(mousey-hexagons(i,2))**2)<=l and hex_1~=i then
			hexagons(hex_1,9):=0
			hexagons(i,9):=1
			hex_2:=i
		    end if
		end for
		if hexagons(hex_1,9)=0 then
		    exit
		end if
	    end if
	end loop
    else %if it's computer's turn the computer will pick a location where there is a red city or settlement
	loop
	    hex_2:=Rand.Int(1,19)
	    exit when hex_2~=hex_1 and (hexagons(hex_2,5)>0 or hexagons(hex_2,6)>0)
	end loop
	hexagons(hex_1,9):=0
	hexagons(hex_2,9):=1
    end if
    var re:int:=0
    if turn mod 2=0 then %the robber steals a resource
	if hexagons(hex_2,7)>0 or hexagons(hex_2,8)>0 then
	    loop
		re:=Rand.Int(1,5)
		exit when p2_hand(re)>0
	    end loop
	    p2_hand(re)-=1
	    p1_hand(re)+=1
	    display_board
	    Draw.Text (rs(re)+" was stolen", 800,740, Font.New ("arial:18"),yellow) 
	end if
    else
	if hexagons(hex_2,5)>0 or hexagons(hex_2,6)>0 then
	    loop
		re:=Rand.Int(1,5)
		exit when p1_hand(re)>0
	    end loop
	    p1_hand(re)-=1
	    p2_hand(re)+=1  
	    display_board
	    Draw.Text (rs(re)+" was stolen", 800,740, Font.New ("arial:18"),yellow) 
	end if    
    end if
    if re=0 then
	display_board
    end if
    delay(1000)
end robber

proc display_hand (hand:array 1..* of int) %it displays the hand
    cls
    Draw.FillBox (0, 0, 1000, 1000, 28)
    Pic.Draw (pics (13),800, 700, picMerge)
    var x_p:int:=0
    var y_p:int:=920
    for i:1..5 % displays the resource cards
	for j:1..hand(i)
	    Pic.Draw (pics (19+i),x_p,y_p, picMerge)
	    x_p+=80
	    if j mod 10 =0 then
		x_p:=0
		y_p-=87
	    end if
	end for
	x_p:=0
	y_p:=920-174*i
    end for
    y_p:=0
    % it displays the ports 
    if hand(11)>0 then
	Pic.Draw (pics (14),800,520, picMerge)
    end if
    if hand(12)>0 then
	Pic.Draw (pics (15),920,520, picMerge)
    end if
    if hand(13)>0 then
	Pic.Draw (pics (16),800,400, picMerge)
    end if
    if hand(14)>0 then
	Pic.Draw (pics (17),920,400, picMerge)
    end if
    if hand(15)>0 then
	Pic.Draw (pics (18),800,280, picMerge)
    end if
    if hand(16)>0 then
	Pic.Draw (pics (19),920,280, picMerge)  
    end if 
    if hand(16)=0 then
	Draw.Text ("Trade 4 to 1", 840,640, Font.New ("arial:18"),black)
    end if
    if hand(6)>0 then %displays the development cards
	Pic.Draw (pics (25),0,y_p, picMerge)
	Draw.Text ("* "+intstr(hand(6)), 100,y_p+60, Font.New ("arial:18"),black)
    end if
    if hand(7)>0 then
	Pic.Draw (pics (26),160,y_p, picMerge)
	Draw.Text ("* "+intstr(hand(7)), 260,y_p+60, Font.New ("arial:18"),black)
    end if
    if hand(8)>0 then
	Pic.Draw (pics (27),320,y_p, picMerge)
	Draw.Text ("* "+intstr(hand(8)), 420,y_p+60, Font.New ("arial:18"),black)
    end if
    if hand(9)>0 then
	Pic.Draw (pics (28),480,y_p, picMerge)
	Draw.Text ("* "+intstr(hand(9)), 580,y_p+60, Font.New ("arial:18"),black)
    end if
    if hand(10)>0 then
	Pic.Draw (pics (29),640,y_p, picMerge)
	Draw.Text ("* "+intstr(hand(10)), 740,y_p+60, Font.New ("arial:18"),black)
    end if
    if hand(17)>0 then
	Pic.Draw (pics (30),900,140, picMerge)
    end if
    if hand(18)>0 then
	Pic.Draw (pics (31),900,0, picMerge)
    end if
    
    if turn mod 2=0 then
	Draw.Text ("Army: "+intstr(p1_army_count), 810,200, Font.New ("arial:16"),black) 
	Draw.Text ("Road: "+intstr(p1_road_count), 810,60, Font.New ("arial:16"),black) 
    else
	Draw.Text ("Army: "+intstr(p2_army_count), 810,200, Font.New ("arial:16"),black) 
	Draw.Text ("Road: "+intstr(p2_road_count), 810,60, Font.New ("arial:16"),black)     
    end if
    % draws the boarder around the display menu
    Draw.ThickLine(0,833,800,833,5,black)
    Draw.ThickLine(0,659,800,659,5,black)
    Draw.ThickLine(0,485,800,485,5,black)
    Draw.ThickLine(0,311,800,311,5,black)
    Draw.ThickLine(0,137,800,137,5,black)
    Draw.ThickLine(800,1000,800,0,5,black)
    Draw.ThickLine(800,600,1000,600,5,black)
    Draw.ThickLine(800,280,1000,280,5,black)
    Draw.ThickLine(1000,1000,1000,0,5,black)

    Draw.FillBox(810,710,985,760,28)
    Draw.Text ("Back", 875,730, Font.New ("arial:16"),black) 
end display_hand

proc hand %takes the players move: either build a settlement city or road or buy a development card or trade
    var copy_hand:array 1..18 of int
    if turn mod 2=0 then
	display_hand(p1_hand)
	for i:1..18
	    copy_hand(i):=p1_hand(i)
	end for
    elsif turn mod 2=1 then
	display_hand(p2_hand)
	for i:1..18
	    copy_hand(i):=p2_hand(i)
	end for
    end if
    button:=0
    delay(500)
    loop %waits for the players to pick their move: either build a settlement city or road or buy a development card or trade
	Mouse.Where (mousex, mousey, button)
	if button = 1 then
	    if 800<=mousex and mousex<=1000 and mousey>=914 and mousey<=964 and (((turn mod 2=0 and p1_hand(1)>=1 and p1_hand(4)>=1) or (turn mod 2=1 and p2_hand(1)>=1 and p2_hand(4)>=1)) or (turn<=2 and last_settlement~=0)) then
		road:=1 %building a road
		build:=0
		exit
	    elsif 800<=mousex and mousex<=1000 and mousey>=863 and mousey<=913 and (((turn mod 2=0 and p1_hand(1)>=1 and p1_hand(2)>=1 and p1_hand(3)>=1 and p1_hand(4)>=1) or (turn mod 2=1 and p2_hand(1)>=1 and p2_hand(2)>=1 and p2_hand(3)>=1 and p2_hand(4)>=1))or (last_settlement=0 and turn<=2)) then
		if turn mod 2=0 then %building a settlement
		    build:=1
		else
		    build:=3
		end if
		road:=0
		exit
	    elsif 800<=mousex and mousex<=1000 and mousey>=812 and mousey<=862 and ((turn mod 2=0 and p1_hand(3)>=2 and p1_hand(5)>=3) or (turn mod 2=1 and p2_hand(3)>=2 and p2_hand(5)>=3)) then
		if turn mod 2=0 then %building a city
		    build:=2
		else
		    build:=4
		end if
		road:=0
		exit
	    elsif 800<=mousex and mousex<=1000 and mousey>=761 and mousey<=811 then %buys a development card
		if turn>2 and ((turn mod 2=0 and p1_hand(2)>=1 and p1_hand(3)>=1 and p1_hand(5)>=1) or (turn mod 2=1 and p2_hand(2)>=1 and p2_hand(3)>=1 and p2_hand(5)>=1)) then
		    victory
		    cls
		    if turn mod 2=0 then
			display_hand(p1_hand)
		    elsif turn mod 2=1 then
			display_hand(p2_hand)
		    end if
		end if
	    elsif 0<=mousex and mousex<=100 and mousey>=0 and mousey<=130 and copy_hand(6)>0 and play_one=0 then %knight selected
		copy_hand(6)-=1
		largest_army
		robber
		cls
		if turn mod 2=0 then
		    display_hand(p1_hand)
		elsif turn mod 2=1 then
		    display_hand(p2_hand)
		end if
	    elsif 320<=mousex and mousex<=420 and mousey>=0 and mousey<=130 and copy_hand(8)>0 and play_one=0 then %monopoly selected
		copy_hand(8)-=1
		monopoly
		cls
		if turn mod 2=0 then
		    display_hand(p1_hand)
		elsif turn mod 2=1 then
		    display_hand(p2_hand)
		end if
	    elsif 480<=mousex and mousex<=580 and mousey>=0 and mousey<=130 and copy_hand(9)>0 and play_one=0 then %year of plenty selected
		copy_hand(9)-=1
		year_of_plenty
		cls
		if turn mod 2=0 then
		    display_hand(p1_hand)
		elsif turn mod 2=1 then
		    display_hand(p2_hand)
		end if
	    elsif 640<=mousex and mousex<=740 and mousey>=0 and mousey<=130 and copy_hand(10)>0 and play_one=0 then %road building selected
		copy_hand(10)-=1
		road_building
		cls
		if turn mod 2=0 then
		    display_hand(p1_hand)
		elsif turn mod 2=1 then
		    display_hand(p2_hand)
		end if
	    elsif 800<=mousex and mousex<=880 and mousey>=520 and mousey<=600 and copy_hand(11)>0 and turn>2 then %harbor_1 selected
		harbor(1)
		cls
		if turn mod 2=0 then
		    display_hand(p1_hand)
		elsif turn mod 2=1 then
		    display_hand(p2_hand)
		end if
	    elsif 920<=mousex and mousex<=1000 and mousey>=520 and mousey<=600 and copy_hand(12)>0 and turn>2 then %harbor_2 selected
		harbor(2)
		cls
		if turn mod 2=0 then
		    display_hand(p1_hand)
		elsif turn mod 2=1 then
		    display_hand(p2_hand)
		end if
	    elsif 800<=mousex and mousex<=880 and mousey>=400 and mousey<=480 and copy_hand(13)>0 and turn>2 then %harbor_3 selected
		harbor(3)
		cls
		if turn mod 2=0 then
		    display_hand(p1_hand)
		elsif turn mod 2=1 then
		    display_hand(p2_hand)
		end if
	    elsif 920<=mousex and mousex<=1000 and mousey>=400 and mousey<=480 and copy_hand(14)>0 and turn>2 then %harbor_4 selected
		harbor(4)
		cls
		if turn mod 2=0 then
		    display_hand(p1_hand)
		elsif turn mod 2=1 then
		    display_hand(p2_hand)
		end if
	    elsif 800<=mousex and mousex<=880 and mousey>=280 and mousey<=360 and copy_hand(15)>0 and turn>2 then %harbor_5 selected
		harbor(5)
		cls
		if turn mod 2=0 then
		    display_hand(p1_hand)
		elsif turn mod 2=1 then
		    display_hand(p2_hand)
		end if
	    elsif 920<=mousex and mousex<=1000 and mousey>=280 and mousey<=360 and copy_hand(16)>0 and turn>2 then %harbor_6 selected
		harbor(6)
		cls
		if turn mod 2=0 then
		    display_hand(p1_hand)
		elsif turn mod 2=1 then
		    display_hand(p2_hand)
		end if
	    elsif 840<=mousex and mousex<=970 and mousey>=620 and mousey<=680 and turn>2 then %4 to 1 selected
		harbor(7)
		cls
		if turn mod 2=0 then
		    display_hand(p1_hand)
		elsif turn mod 2=1 then
		    display_hand(p2_hand)
		end if
	    elsif 800<=mousex and mousex<=1000 and mousey>=710 and mousey<=760 then %back button selected
		exit
	    end if
	end if
    end loop
    button:=0
    display_board
    delay(500)
end hand

proc dice_roll %does the dice roll
    for i:1..20 %the dice are rolled 20 times to show the dice roll
	dice(1):=Rand.Int(1,6)
	dice(2):=Rand.Int(1,6)
	Pic.Draw (pics (31+dice(1)),746, 775, picMerge)
	Pic.Draw (pics (31+dice(2)),872, 775, picMerge)
	delay(25) 
	Draw.FillBox (746, 775, 826,855,54)
	Draw.FillBox (872, 775, 952,855,54)
    end for 
    dice(1):=Rand.Int(1,6) %then it shows the dice
    dice(2):=Rand.Int(1,6)
    Pic.Draw (pics (31+dice(1)),746, 775, picMerge)
    Pic.Draw (pics (31+dice(2)),872, 775, picMerge)  
end dice_roll

function can_play:boolean %it checks to see if the player can play
    var b1:int:=5
    var b2:int:=6
    var r1:int:=2
    var hh:int:=0
    for i:1..upper(vertices) %checks to see if they can build a city or a settlement
	if check_vertex(vertices(i,1),vertices(i,2),b1,hh)=true or check_vertex(vertices(i,1),vertices(i,2),b2,hh)=true then
	    result true
	end if
    end for
    for i:1..upper(roads)
	if roads(i,5)=0 then %checks to see if they can build a road
	    if check_side((sides(i,1)+sides(i,3))div 2,(sides(i,2)+sides(i,4))div 2,road_up,r1,hh)=true then
		result true
	    end if
	end if
    end for
    if p1_hand(2)>0 and p1_hand(3)>0 and p1_hand(5)>0 then %checks to see if they can build a development card
	result true
    end if
    if p1_hand(6)>0 or p1_hand(8)>0 or p1_hand(9)>0 or p1_hand(10)>0 then %checks to see if they can use a development card
	result true
    end if
    if (p1_hand(11)=1 and p1_hand(3)>=2)or(p1_hand(12)=1 and p1_hand(5)>=2)or(p1_hand(13)=1 and p1_hand(4)>=2)or(p1_hand(14)=1 and p1_hand(1)>=2)or(p1_hand(15)=1 and p1_hand(2)>=2)or(p1_hand(16)=1 and (p1_hand(1)>=3 or p1_hand(2)>=3 or p1_hand(3)>=3 or p1_hand(4)>=3 or p1_hand(5)>=3))or p1_hand(1)>=4 or p1_hand(2)>=4 or p1_hand(3)>=4 or p1_hand(4)>=4 or p1_hand(5)>=4 then
	%checks to see if they can trade    
	result true
    end if
    result false
end can_play

proc test %test mode gives more resources and development cards so they can be checked
    if test_mode=true then
       p1_hand(1)+=10
       p1_hand(2)+=10
       p1_hand(3)+=10
       p1_hand(4)+=10
       p1_hand(5)+=10 
       p1_hand(6)+=1 
       p1_hand(8)+=1 
       p1_hand(9)+=1 
       p1_hand(10)+=1 
       p2_hand(1)+=10
       p2_hand(2)+=10
       p2_hand(3)+=10
       p2_hand(4)+=10
       p2_hand(5)+=10  
       p2_hand(6)+=1 
       p2_hand(8)+=1 
       p2_hand(9)+=1 
       p2_hand(10)+=1   
    end if
end test

proc next
    if ((turn=0 or turn=2) and r_count=1 and s_count=1) or turn=1 or turn>2 then %it only looks at the next turn if they have build enough settlements and roads for first two turns
	  s_count:=0
	  r_count:=0
	  if turn=1 then
	       p2_hand(1):=init_resources(1)
	       p2_hand(2):=init_resources(2)
	       p2_hand(3):=init_resources(3)
	       p2_hand(4):=init_resources(4)
	       p2_hand(5):=init_resources(5)
	       resources(1)-=init_resources(1)
	       resources(2)-=init_resources(2)
	       resources(3)-=init_resources(3)
	       resources(4)-=init_resources(4)
	       resources(5)-=init_resources(5)
	 elsif turn=2 then
	       p1_hand(1):=init_resources(1)
	       p1_hand(2):=init_resources(2)
	       p1_hand(3):=init_resources(3)
	       p1_hand(4):=init_resources(4)
	       p1_hand(5):=init_resources(5)             
	       resources(1)-=init_resources(1)
	       resources(2)-=init_resources(2)
	       resources(3)-=init_resources(3)
	       resources(4)-=init_resources(4)
	       resources(5)-=init_resources(5)
	       test
	 end if
	 if turn<=2 then
	      init_build:=0
	      init_resources(1):=0
	      init_resources(2):=0
	      init_resources(3):=0
	      init_resources(4):=0
	      init_resources(5):=0
	end if
	turn+=1
	if turn>2 then
	     dice_roll
	     if dice(1)+dice(2)=7 then
		 if test_mode=false then
		      interface_7
		 end if
		 robber
		 display_board
	    end if
	    for i:1..19 %assigns resources based on the hexagons besides each vertex
		 if hexagons(i,4)=dice(1)+dice(2) and hexagons(i,9)=0 then
		     p1_hand(hexagons(i,3))+=hexagons(i,5)+2*hexagons(i,6)
		     resources(hexagons(i,3))+=hexagons(i,5)+2*hexagons(i,6)
		     p2_hand(hexagons(i,3))+=hexagons(i,7)+2*hexagons(i,8)      
		     resources(hexagons(i,3))+=hexagons(i,7)+2*hexagons(i,8)
		 end if
	    end for
	    if turn mod 2=0 then
		 play_one:=0
		 if can_play=false then
		     Draw.Text ("Pass", 800,740, Font.New ("arial:18"),white)
		     delay(500) 
		     next
		 end if
	    end if
      end if
      display_board
   end if
end next

proc computer_play %this is the AI
    var random:int:=0
    var check:flexible array 1..0 of int
    var check2:flexible array 1..0 of int
    var check3:flexible array 1..0 of int
    var in_count:int:=0
    var AI_build:int:=5
    if turn<=2 then
	var hexes:flexible array 1..0 of int
	loop
	    build:=3
	    new check,0
	    loop
		exit when upper(check)=54
		loop
		    random:=Rand.Int(1,upper(vertices))
		    if exists(random,check)=false then
			new check,upper(check)+1
			check(upper(check)):=random
			new hexes,0
			for j:1..19 %it puts settlements only if there are three hexes connected to it
			    if sqrt ((vertices (random, 1) - hexagons (j, 1)) ** 2 + (vertices (random, 2) - hexagons (j, 2)) ** 2) <= floor(l*sqrt(3))+5 then 
				new hexes,upper(hexes)+1
				hexes(upper(hexes)):=j  
			    end if
			end for
			if upper(hexes)=3 then
			    if hexagons(hexes(1),3)~=6 and hexagons(hexes(2),3)~=6 and hexagons(hexes(3),3)~=6 then
				 exit
			    end if
			end if
		    end if
		    exit when upper(check)=54
		end loop
		if vertices(random,3)=0 then
		    if check_vertex(vertices(random,1),vertices(random,2),build,1) then
			in_count+=1
			comp_s+=1
			exit
		    end if
		end if  
	    end loop
    
	    road:=1
	    new check,0
	    loop
		exit when upper(check)=72 %it also gives them roads
		loop
		    random:=Rand.Int(1,upper(roads))
		    if exists(random,check)=false then
			new check,upper(check)+1
			check(upper(check)):=random
			exit
		    end if
		    exit when upper(check)=54
		end loop
		if roads(random,5)=0 then
		    if check_side ((sides(random,1)+sides(random,3)) div 2, (sides(random,2)+sides(random,4)) div 2, road_up,road,1) then
			in_count+=1
			comp_r+=1
			exit
		    end if
		end if  
	    end loop
	    exit when in_count=4
	end loop
	s_count:=0
	r_count:=0
    elsif turn>2 then
	var dev:int
	loop %it checks to see if the computer can play a development card
	    exit when p2_hand(6)=0 and p2_hand(8)=0 and p2_hand(9)=0 and p2_hand(10)=0 
	    dev:=Rand.Int(1,4)
	    if p2_hand(6)>0 and dev=1 then
		largest_army
		display_board
		robber
		delay(1000)
		exit
	    elsif p2_hand(8)>0 and dev=2 then
		monopoly
		exit
	    elsif p2_hand(9)>0 and dev=3 then
		year_of_plenty
		exit
	    elsif p2_hand(10)>0 and dev=4 then
		road_building
		display_board
		delay(1000)
		exit
	    end if
	end loop
	
	for i:1..6 %it checks to see if the computer can do any trades. It only trades if there is zero cards for a resource
	    if p2_hand(10+i)=1 then
		if p2_hand(1)=0 or p2_hand(2)=0 or p2_hand(3)=0 or p2_hand(4)=0 or p2_hand(5)=0 then
		    harbor(i)
		end if
	    end if
	end for
	if p2_hand(1)=0 or p2_hand(2)=0 or p2_hand(3)=0 or p2_hand(4)=0 or p2_hand(5)=0 then
	      harbor(7)
	end if
	
	loop
	    build:=4
	    loop %it tries to build cities first
		random:=Rand.Int(1,upper(vertices))
		if exists(random,check)=false then
		    new check,upper(check)+1
		    check(upper(check)):=random
		    exit
		end if
		exit when upper(check)>=54
	    end loop
	    if vertices(random,3)=3 then
		if check_vertex(vertices(random,1),vertices(random,2),build,1) and abs(comp_c-comp_s)<=2 then
		    in_count+=1 
		    comp_c+=1
		    comp_s-=1
		end if
	    end if  

	    build:=3
	    loop %then settlements
		random:=Rand.Int(1,upper(vertices))
		if exists(random,check2)=false then
		    new check2,upper(check2)+1
		    check2(upper(check2)):=random
		    exit
		end if
		exit when upper(check2)>=54
	    end loop
	    if vertices(random,3)=0 then
		if check_vertex(vertices(random,1),vertices(random,2),build,1) and comp_s<=comp_c+2 then
		    in_count+=1 
		    comp_s+=1
		end if
	    end if  
    
	    road:=1
	    loop %then roads
		random:=Rand.Int(1,upper(roads))
		if exists(random,check3)=false then
		    new check3,upper(check3)+1
		    check3(upper(check3)):=random
		    exit
		end if
		exit when upper(check3)>=72
	    end loop
	    if roads(random,5)=0 then
		if check_side ((sides(random,1)+sides(random,3)) div 2, (sides(random,2)+sides(random,4)) div 2, road_up,road,1) and comp_r<=comp_s+5 then
		   in_count+=1 
		   comp_r+=1
		end if
	    end if 
	    exit when upper(check)>=54 or upper(check2)>=54 or upper(check3)>=72
	end loop
	if p2_hand(1)+p2_hand(2)+p2_hand(3)+p2_hand(4)+p2_hand(5)>= 7 then %if it has more than 7 cards it will buy a development card
	    victory
	end if
    end if
    build:=0
    road:=0
    display_board
end computer_play

load_images
draw_board ("i")

loop
    Mouse.Where (mousex, mousey, button)
    if button = 1 and turn mod 2=0 then
	if 770<=mousex and mousex<=1000 and mousey>=880 and mousey<=950 then %next button pressed
	    next
	elsif 70<=mousex and mousex<=230 and mousey>=805 and mousey<=965 then %hand button pressed
	    hand
	elsif build~=0 and (((turn=0 or turn=2) and s_count=0) or (turn=1 and s_count<=1) or turn>2)then
	    if check_vertex (mousex, mousey, build,1) = true then
		%vertex selected
	    end if
	elsif View.WhatDotColour (mousex, mousey) = 7 and road=1 and (((turn=0 or turn=2) and r_count=0) or (turn=1 and r_count<=1) or turn>2) then
	    if check_side (mousex, mousey, road_up,road,1) = true then
		%side selected
	    end if
	end if
	delay (500)
    elsif turn mod 2=1 then %if turn is odd it loads computer play
	computer_play
	delay(500)
	next
    end if
    %find the winner
    if p1_vp>=10 then
	delay(1000)
	cls
	Draw.FillBox (0, 0, 1000, 1000, 54)
	Draw.Text ("Player One Wins", 400,400, Font.New ("arial:18"),white)
	exit
    elsif p2_vp>=10 then
	delay(1000)
	cls
	Draw.FillBox (0, 0, 1000, 1000, 54)
	Draw.Text ("Player Two Wins", 400,400, Font.New ("arial:18"),white)
	exit
    end if
end loop
