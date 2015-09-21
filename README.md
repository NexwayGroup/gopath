Portable GOPATH, inspired from an [original idea](https://medium.com/iron-io-blog/the-easiest-way-to-develop-with-go-introducing-a-docker-based-go-tool-c456238507d6) by Travis Reeder.

This project takes it further by:
- mapping the current folder directly into the container's GOPATH
- preloading & locking dependencies
- bridging the `go` command transparently

No need to install Go or setup the GOPATH, still it works and behaves as if it was installed locally.

### Getting started
:warning: Most likely you will want to fork this repo, preload your own deps.

```
docker pull jgautheron/go
```

To map transparently commands with Go, I recommend adding the following to your `.bashrc` (Linux/Bash), `.bash_profile` (OSX/Bash), or `.zshrc`:
```bash
go() {
    local repo=$(basename ${PWD})
    local user=${${PWD%/*}##*/}
    docker run --rm -v $PWD:/root/go/src/github.com/$user/$repo -w /root/go/src/github.com/$user/$repo jgautheron/go $@
}
```
Then reload your file, ex. `source ~/.zshrc`.

All `go` commands can be called directly:
```bash
$ go build .`
```

For calling binaries installed in the `GOBIN`, prefix it with `go`:
```bash
$ go golint .`
```

### Locking dependencies
Let's say you're working in large teams and would like to lock the dependencies that can be used (by example, allow only `logrus` for logging), then you can just preload libs in your `company/go` container.

### Sublime Text + GoSublime
If you use GoSublime with Sublime Text, you're most likely running automatically several Go tools.
Here's a sample GoSublime settings file configured to map commands to the container:
```json
{
    "shell": ["/bin/zsh", "--login", "-c", "source ~/.zshrc; eval $(boot2docker shellinit); $CMD"],
    "fmt_cmd": ["go goimports"],
    "on_save": [{
        "cmd": "gs9o_open", "args": {
        "run": [
            "sh",
            "go build . errors && go test"
        ],
        "focus_view": false
        }
    }]
}
```

Since I'm running `zsh` on OSX with `boot2docker`, I load the file which contains my `go` function, inject the VM variables, then finally execute the given `$CMD`.

### Credits
- [treeder/go](https://github.com/treeder/go)