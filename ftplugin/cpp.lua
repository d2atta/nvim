vim.wo.relativenumber = true
vim.wo.number = true

local fileBase = vim.fn.expand("%:r")
vim.bo.makeprg = "gcc -std=c++17 -O2 -g -fsanitize=address -fsanitize=undefined -D_GLIBCXX_DEBUG -Wshadow -Wall % -o "
	.. fileBase

local function snippet()
	vim.api.nvim_put({
		"/*********************/",
		"/* Handle: devildev */",
		"/*********************/",
		"#include<bits/stdc++.h>",
		"using namespace std;",
		"",
		"/* alias */",
		"typedef vector<int> VI;",
		"typedef pair<int,int> PI;",
		"typedef map<int,int> MI;",
		"typedef set<int> SI;",
		"typedef multiset<int> MSI;",
		"",
		"/* short codes */",
		"#define ll long long",
		"#define ld long double",
		"#define ar array",
		"#define REP(i,a,b) for(int i = a; i <= b ; i++)",
		"#define SQ(a) (a)*(a)",
		"#define F first",
		"#define S second",
		"#define PB push_back",
		"#define MP make_pair",
		"",
		"/* constants */",
		"const ll INF = (int)1e9;",
		"const ll MOD = 1e9+7;",
		"",
		"/* soltion */",
		"int solve() {",
		"  int n,k,a,b,c,d;",
		"",
		"  return 0;",
		"}",
		"",
		"/* main */",
		"int main() {",
		"#ifndef ONLINE_JUDGE",
		'  freopen("input.txt","r",stdin);',
		"#endif",
		"",
		"  ios::sync_with_stdio(0);",
		"  cin.tie(0);",
		"  int t;",
		"  cin >> t;",
		"  REP(i,0,t) {",
		'    //cout<<"Case #"<<i+1<<": ";',
		"    solve();",
		"  }",
		"}",
	}, "l", false, true)
end
vim.keymap.set({ "n", "i" }, "<C-k>", snippet, { buffer = 0 })
