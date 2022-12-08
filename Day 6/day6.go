package main

import (
	"fmt"
	"os"
	"strings"
)

func main() {
	buffer := readBuffer("inputDay6")
	fmt.Println(findStart(buffer, 4))
	fmt.Println(findStart(buffer, 14))

}

func readBuffer(path string) string {
	data, err := os.ReadFile(path)
	if err != nil {
		panic(err)
	}
	return string(data)
}

func findStart(buffer string, size int) int {
	return findStartRecursive("", buffer, size)
}

func findStartRecursive(current string, future string, size int) int {
	future, candidate := pop(future)

	if len(candidate) == 0 {
		panic("no match found")
	}

	// Check if candidate is in current and at what position
	if index := strings.IndexAny(current, candidate); index != -1 {
		return 1 + findStartRecursive(fmt.Sprint(current[index+1:], candidate), future, size)
	}

	current = fmt.Sprint(current, candidate)

	// Check if current is now a big enough to be a match
	if len(current) == size {
		return 1
	}
	// Not long enough to be match, so continue
	return 1 + findStartRecursive(current, future, size)

}

func pop(input string) (remaining string, popped string) {
	if len(input) != 0 {
		remaining, input = input[1:], input[0:1]
		return
	} else {
		return "", ""
	}
}
