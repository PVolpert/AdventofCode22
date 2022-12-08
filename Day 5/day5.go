package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

type moveOrder struct {
	move int
	from int
	to   int
}

func main() {
	orders, cargoMap := readFile()
	// We need to copy cargoMap to prevent double assignments
	cargo9000 := make([][]string, len(cargoMap))
	cargo9001 := make([][]string, len(cargoMap))
	copy(cargo9000, cargoMap)
	copy(cargo9001, cargoMap)
	cargo9000 = doOrders9000(orders, cargo9000)
	cargo9001 = doOrders9001(orders, cargo9001)
	fmt.Println(readPriorityCargo(cargo9000))
	fmt.Println(readPriorityCargo(cargo9001))

}

func readFile() (orders []moveOrder, cargoMap [][]string) {
	file, err := os.Open("./inputDay5")
	if err != nil {
		panic(err)
	}
	scanner := bufio.NewScanner(file)

	flag := true
	temp := make([]string, 0)
	for scanner.Scan() {
		text := scanner.Text()

		if flag {
			if len(text) == 0 {
				flag = false
				cargoMap = mapCargoStructure(temp)
				continue
			}
			//Store structure of cargo until we get the numbers line
			temp = append(temp, text)
			continue
		}
		//If flag is false then only orders follow
		orders = append(orders, readMoveOrder(text))
	}
	if err := scanner.Err(); err != nil {
		panic(err)
	}
	return
}

func readMoveOrder(input string) (order moveOrder) {
	splitString := strings.Fields(input)
	//we know the structure of a move command
	//move X from Y to Z
	//as such we know which position the X,Y and Z have
	order.move, _ = strconv.Atoi(splitString[1])
	order.from, _ = strconv.Atoi(splitString[3])
	order.to, _ = strconv.Atoi(splitString[5])
	return
}

func Reverse(input []string) []string {
	var output []string
	for i := len(input) - 1; i >= 0; i-- {
		output = append(output, input[i])
	}
	return output
}

func mapCargoStructure(input []string) [][]string {
	// We use the numberRow to parse the number of rows
	numberRow := strings.Fields(input[len(input)-1])
	rowAmount, _ := strconv.Atoi(numberRow[len(numberRow)-1])

	cargoMap := make([][]string, rowAmount)
	input = input[:len(input)-1]
	for _, val := range Reverse(input) {
		for row := 0; row < rowAmount; row++ {
			// We can pinpoint the position of the cargo in the input file
			candidate := string(val[1+row*4])
			// Ignore empty cargo spots
			if candidate != " " {
				cargoMap[row] = append(cargoMap[row], candidate)
			}
		}
	}
	return cargoMap
}

func doOrders9000(orders []moveOrder, cargoMap [][]string) [][]string {
	for _, order := range orders {
		cargoMap[order.to-1] = append(cargoMap[order.to-1], Reverse(cargoMap[order.from-1])[:order.move]...)
		cargoMap[order.from-1] = cargoMap[order.from-1][:len(cargoMap[order.from-1])-order.move]
	}
	return cargoMap
}

func doOrders9001(orders []moveOrder, cargoMap [][]string) [][]string {
	for _, order := range orders[:] {
		Stack := Reverse(cargoMap[order.from-1])[:order.move]
		cargoMap[order.to-1] = append(cargoMap[order.to-1], Reverse(Stack)...)
		cargoMap[order.from-1] = cargoMap[order.from-1][:len(cargoMap[order.from-1])-order.move]
	}
	return cargoMap
}

func readPriorityCargo(cargoMap [][]string) (priorityCargo string) {
	for _, cargo := range cargoMap {
		priorityCargo = priorityCargo + cargo[len(cargo)-1]
	}
	return
}
