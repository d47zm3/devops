# NWT Components

## Installation

### Preconditions
    * Nodejs
    * NPM
    
### Process

#### Install dependencies
`npm install`

## Source Directories

* `./src` - Sources root
* `./src/docs` - Root for handlebars pages for docs
* `./src/docs/partials` - Root for handlebars partials used on docs pages
* `./src/fonts` - Place for fonts used from within project
* `./src/images` - Place for images used from within project
* `./src/images/icons` - Root for svg icons used to create svg sprite
* `./src/js` - Place for javascripts
* `./src/scss` - Place for scss files
* `./src/vendors` - Place for outsourced assets

## Commands
### Build assets to dist
Creates single file for javascripts in `./dist/js/app.js`  
Creates single file for styles in `./dist/css/style.css`  
Creates SVG sprite file in `./dics/images/icons.svg`  
Copies all other assets to `./dist`  
Creates static pages from handlebars docs in `./dist`  
`npm run build`

### Tests
_not implemented yet_
`npm run test`

### Lint JS
Will check if Javascripts meet code quality requirements excluding environment (node_modules)

#### once  
`npm run lint:js`

#### watch
`watch:lint:js`


### Lint css
Will check if SCSS meet code quality requirements excluding vendors (src/scss/vendor)

#### once  
`npm run lint:css`

#### watch 
`watch:lint:css`


### lint assets
Will check if SCSS and Javascripts meet code quality requirements

#### once
`npm run lint`

#### watch
`npm run watch:lint`


### Run dev server
Create simple Node server to serve static files

#### Address
`localhost:7774`

#### run
`npm run devServer`


#### Dev environment
Run linters on watch mode
Run webpack on watch mode

`npm run dev`
