# cusspvz/nginx

:earth_americas: a 4MB alpine based nginx docker image, but carried with a
configurable cache among other features

## Another nginx image? Why?

Say WHAATT?? I search a lot, I really do, but unfortunatelly I like to customize
things, get my hands dirty on and make things work. Unfortunatelly most of the
images I've seen have something missing or don't have what I need for now.

As so, I've developed an image which can grant you *TOTAL ACCESS* to the
*nginx.conf* file.
(Well, part of that its true, whenever you need something this doesn't have,
create an Issue)

## Built to be part of your project

### How to use it?
I've provided an [hello world example] so you can easily understand how you can
couple it with your project.

#### Create a *Dockerfile* based on the *latest* tag

`Dockerfile`
```
FROM cusspvz/nginx:latest
MAINTAINER God <yolo@heaven.org>
```

Easy right?

### Now you must tell me where you have all the public stuff
Computer isn't smart, yet, and I didn't developed an html/css/js auto-finder,
so you must tell your image where you save the precious juice.

Imagine that you have it under `public/` on the root of your project.
Just set up your *Dockerfile* like this:

`Dockerfile`
```
FROM cusspvz/nginx:latest
MAINTAINER God <yolo@heaven.org>

ADD public/ /pub
```

And you're ready to set!

### Building up the image

```
docker build -t dockerusername/yolo .
```

### Executing it

```
docker run -ti -p 80:80 dockerusername/yolo
```

### Seems easy, but do you have a `onbuild` tag, how does it work?
Hell yeah it is.

You can use the `onbuild` tag **ONLY** if you have your public goods on `public/`.
That is the only thing the `onbuild` does, adding a folder as `/pub`

`Dockerfile`
```
FROM cusspvz/nginx:onbuild
MAINTAINER God <yolo@heaven.org>
```

## Customizing

Here's the good part!!! :D

### PUBLIC_PATH
#### Defaults to: `/pub`
Allows you to change the target root directory inside the container.

**NOTE:** If you change this, you will need to change your public content `ADD`
statements as well.

### NGINX_CONF
#### Defaults to: `/etc/nginx/boot.conf`
Sets the path of the generated nginx config gile.

### WORKER_CONNECTIONS
#### Defaults to: `1024`
Change this if you need to serve more connections

### HTTP_PORT
#### Defaults to: `80`
Sets the listening http port.

**NOTE:** If you change this you will also to have sure you set the right port
whenever you run a new container based on your image.

### GZIP_TYPES`
#### Defaults to: `application/javascript application/x-javascript application/rss+xml text/javascript
text/css image/svg+xml`
We already compress assets, if you have more assets you need to compress, please
change this line. If you think I've missed some of them here, please PR the
changes or open a new Issue! :)

### GZIP_LEVEL
#### Defaults to: `6`
I like to maintain compression somewhere in the middle, so we can average the
**network vs cpu** usage.

### CACHE_IGNORE
#### Defaults to: `html`
We're ignoring cache for HTMLs because they are usually who target other assets.
Feel free to set this empty in case you need to cache them.

### CACHE_PUBLIC
#### Defaults to: `"ico|jpg|jpeg|png|gif|svg|js|jsx|css|less|swf|eot|ttf|otf|woff|woff2"`
All html assets should be cached, so you can have a fast website and a great SEO.

### CACHE_PUBLIC_EXPIRATION
#### Defaults to: `1y`
By default, I believe all your static assets should live, at least, for a year
on your visitors computer. If you disagree, feel free to change.


## Final comments

Now you can: *sayy WHHAAAATTT??*

## Examples:
- [hello world example]

## Contributing
Feel free to create Issues or Pull Requests.


[hello world example]: https://github.com/cusspvz/nginx.docker/tree/master/examples/hello-world
