
# wintersmith-less

[less](http://lesscss.org) plugin for [wintersmith](https://github.com/jnordberg/wintersmith)

install:

`npm install wintersmith-less -g`
then add `wintersmith-less` to your plugins in the wintersmith config


## Options

Add a less key to your wintersmith config, all options are passed directly to the less parser with the exeption of the `excluded` list. Which can be a list of files to exclude from rendering (for example configuration and library files). Files that has filenames starting with underscore (`_`) are automatically excluded.

```json
{
	"less": {
		"exclude": "styles/configuration.less"
	}
}
```

