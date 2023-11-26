package main

import (
	"crypto/md5"
	"encoding/hex"
	"regexp"
	"sort"
	"strconv"
)

func applyHash(input string) string {

	hash := ""
	for i := 0; i < 2017; i++ {
		hasher := md5.New()
		hasher.Write([]byte(input))
		hash = hex.EncodeToString(hasher.Sum(nil))
		input = hash
	}
	return hash
}

var re3 = regexp.MustCompile(`(aaa|bbb|ccc|ddd|eee|fff|000|111|222|333|444|555|666|777|888|999)`)
var re5 = regexp.MustCompile(`(aaaaa|bbbbb|ccccc|ddddd|eeeee|fffff|00000|11111|22222|33333|44444|55555|66666|77777|88888|99999)`)
var salt = "zpqevtbw"

func main() {
	curr := 0
	keys := []int{}
	hashes := map[int]byte{}
	for len(keys) < 64 {
		println(curr)
		hash := applyHash(salt + strconv.Itoa(curr))

		triplet := re3.FindString(hash)

		if triplet == "" {
			curr += 1
			for i, _ := range hashes {
				if i+1000 < curr {
					delete(hashes, i)
				}
			}
			continue
		}

		found := triplet[0]

		quintuple := re5.FindString(hash)
		if quintuple != "" {
			foundQ := quintuple[0]
			toRemove := []int{}
			for i, s := range hashes {
				if foundQ == s {
					keys = append(keys, i)
					toRemove = append(toRemove, i)
				}
			}
			for _, i := range toRemove {
				delete(hashes, i)
			}
		}

		hashes[curr] = found

		curr += 1

		for i, _ := range hashes {
			if i+1000 < curr {
				delete(hashes, i)
			}
		}

	}
	sort.Slice(keys, func(i, j int) bool {
		return keys[i] < keys[j]
	})
	println(keys[63])
}
