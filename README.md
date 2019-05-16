# jekyll-simple-i18n

A simple approach to internationalization for [Jekyll](https://jekyllrb.com/) websites.

### Features

* No external dependencies. Plugins utilize existing Jekyll features.
* Source strings and page titles can be placed directly in templates for seamless editing and readability.
* A ready-to-translate YAML file that includes all of the canonical source strings is generated every time the site is built.
* It's easy to add new languages. Just create a single file that contains the translated strings. Everything else happens automatically.
* Custom [front matter](https://jekyllrb.com/docs/front-matter/) is added to translated pages that can be used within your Liquid templates.
* Optional [Transifex](https://www.transifex.com/) integration.
* Built-in support for [hreflang tags](https://en.wikipedia.org/wiki/Hreflang).

### Demo

1. Clone the repo. Run `bundle install --deployment` inside the cloned directory.
2. Build the site: `bundle exec jekyll build`.
3. You'll notice that a source file (`transifex-source-file.yml`) has been automatically generated.
   * New strings can be added to any page using the custom Liquid tag: `{% translate This is a new string. %}`
4. The `_site` directory includes generated content for each supported language.
   * Adding a new language is as simple as placing a translated source file in the `_data/languages/` directory.
   * Add `translate: true` in the Jekyll front matter for any page that you want to be translated.
5. As new source strings are added, simply update the translated string files.
   * When a translation isn't available, the source string is automatically used by default.
   * The sample Transifex config (`.tx/config`) demonstrates how this can be integrated into an existing project to automate the push and pull of translation updates.
     * You can also manually translate the source file or leverage a different service.
6. Try modifying `index.html` and creating new pages. Once you understand how everything works, you can copy the plugins and data structure into your own project.

### Advanced usage

#### In-progress translations
Every `{% translate %}` tag is added to the source file, but translated pages for that content will only be generated when `translate: true` is set in the page's front matter. This gives you an easy way to get started on new translations without deploying them right away.

#### Dynamic links and images
A custom `language` variable is added to the front matter for translated pages. You can use this to make adjustments to links or images:

```liquid
<a href="/{% if page.language %}{{ page.language }}/{% endif %}">Home</a>

<img src="header-image-{{ page.language | default: "en" }}.png" />
```

#### Language iteration, navigation elements, and complex directory structures

A custom `src_dir` variable is also added to the front matter for translated pages. This gives translated pages an easy way to reference the location of the canonical content.

For example, let's say you want to implement a language selector that appears on pages with translated content. Here's how you can do that using the jekyll-simple-i18n plugins alongside built-in Jekyll functionality like [Liquid](https://jekyllrb.com/docs/liquid/) and [Data Files](https://jekyllrb.com/docs/datafiles/):

```liquid
{% if page.translate %}
<li class="dropdown">
  <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false" aria-label="Change Language" id="language-selector"><i class="fas fa-globe"></i> {{ page.language | default: "EN" }} <span class="caret"></span></a>
  <ul class="dropdown-menu" aria-labelledby="language-selector">
    {% if page.src_dir %}
    {% assign dir = page.src_dir %}
    <li><a data-lang="en" href="{{ dir }}">English</a></li>
    {% else %}
    {% assign dir = page.dir %}
    {% endif %}

    {% assign languages = site.data.languages | sort %}
    {% for language_hash in languages %}
    {% assign iterated_language = language_hash[0] %}
    {% if page.language != iterated_language %}
    <li><a data-lang="{{ iterated_language }}" href="/{{ iterated_language }}{{ dir }}">{{ site.data.language_map[iterated_language] }}</a></li>
    {% endif %}
    {% endfor %}
  </ul>
</li>
{% endif %}
```

### License (MIT)

Copyright 2019 Signal

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
