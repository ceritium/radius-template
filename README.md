# Radius::Template

Simple Ruby on Rails wrapper around radius gem.

Based on the work of [Radius Template](https://github.com/macbury/Radius-template).

## Changelog


  * Gemification.
  * Rails 3 compatible.
  * Some performance things.
  * Removed autolink option.
  * Work with any object that respond to method :each, not only ActiveRecord Objects.
  * Changed the naming of vars from composed class names. Example: WebContent: before => webcontent; after => web_content.


## Installation

Add this line to your application's Gemfile:

    gem 'radius-template'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install radius-template

## Usage


### Simple Example

The first argument is a namespace(tag_prefix) for your template

    ``` ruby
    parser = Radius::Template.new("template")

    parser.define_tag 'hello' do |tag|
      who = tag['who']
      "Hello #{who}"
    end

    parser.parse("<template:hello who="wrold" />")   # => "Hello world"
    parser.parse("<template:hello who="Jack" />")    # => "Hello Jack"
    ```

### Passing Variables

In second argument you can pass variables to your template


    ``` ruby
    parser = Radius::Template.new("template", {
      hello: "world",
      number: 2.00
    })

    parser.parse("<template:hello />")   # => "world"
    parser.parse("<template:number />")  # => "2.00"
    ```

### ActiveRecord Objects, Mongoid or any class kind...

The radius radius_attr_accessible tells what attributes will be accessible in the template.


    ``` ruby
    class Post < ActiveRecord::Base
      radius_attr_accessible :title, :body
    end

    parser = Radius::Template.new("blog", {
      today_posts: Post.all,
      top_post: Post.top.first
    })

    # Passing a local variable named posts with Active Record Post array will create this tag <blog:today_posts />" and it is an array with your posts. Inside this tag you will get this tag <blog:post />. The name of this tag is from singleton name of the model. Each attribute specified in radius_attr_accessible is accessible from it(<blog:post:title />, <blog:post:body />).


    template = <<-TEMPLATE
      <ul>
      <blog:today_posts>
        <li>
          <blog:post /><br />
          <blog:post:body>
        </li>
      </blog:today_posts>
      </ul>
      <p>
        <blog:top_post>
          See the top post - <blog:top_post:title />
        <blog:top_post />
      </p>
    TEMPLATE

    parser.parse(template) # =>
    #
    # <ul>
    #   <li>
    #     <a href="/posts/1">The title of the post</a><br />
    #     Hello World!
    #   </li>
    # </ul>
    # <p>
    #   See the top post - Hello World
    # </p>
    ```


### Radius Drops

Drops acts like helpers for your template

Create "drops" directory in app folder and add it to load paths in environment.rb

    ``` ruby
    config.load_paths += %W( #{RAILS_ROOT}/app/drops )
    ```


Next create a text_drop.rb in app/drops dir:


    ``` ruby
    class SimpleDrop < Radius::Drop
      include ActionView::Helpers::TextHelper

      register_tag "truncate" do |tag|
        length = tag['length'] || 255
        truncate(tag.expand, :length => length.to_i)
      end

      register_tag "variable_test" do |tag|
        "#{@a_test_variable} from drop" #you can access variable that your passed into the template
      end
    end
    ```

You must pass drops in the array as third argument



    ``` ruby
    parser = Radius::Template.new("app", {
      a_test_variable: "Hello World"
    }, [SimpleDrop])

    template = <<-TEMPLATE
      <app:truncate length="10">
        Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
      </app:truncate>

      <app:variable_test />
    TEMPLATE

    parser.parse(template) # =>  Lorem ipsum dolor sit amet, co...
                           #     Hello World from Drop

    ```



### Radius Drops + ActiveRecord (or Mongoid or any class kind...)


What if you have a photo url in your active record model and you want to create a image tag?


    ``` ruby
    class ProductsDrop < Radius::Drop

      register_tag "product:photo" do |tag|
        product = tag.locals.product rescue tag.missing!
        if photo
          attributes = tag.attributes.clone
          image_tag(product.photo_url, attributes)
        else
          image_tag("/image/missing.png")
        end
      end

    end

    # <product:photo alt="product photo" /> # => <img src="/images/product/1.png" alt="product photo" />
    ```




## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
