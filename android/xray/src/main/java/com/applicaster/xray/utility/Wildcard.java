package com.applicaster.xray.utility;

public class Wildcard {

    //https://www.programcreek.com/2014/06/leetcode-wildcard-matching-java/
    public static boolean isMatch(String str, String pattern) {
        int i = 0;
        int j = 0;
        int starIndex = -1;
        int iIndex = -1;

        while (i < str.length()) {
            if (j < pattern.length() && (pattern.charAt(j) == '?' || pattern.charAt(j) == str.charAt(i))) {
                ++i;
                ++j;
            } else if (j < pattern.length() && pattern.charAt(j) == '*') {
                starIndex = j;
                iIndex = i;
                j++;
            } else if (starIndex != -1) {
                j = starIndex + 1;
                i = iIndex+1;
                iIndex++;
            } else {
                return false;
            }
        }

        while (j < pattern.length() && pattern.charAt(j) == '*') {
            ++j;
        }

        return j == pattern.length();
    }
}
