# GraphQL::Sources

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add graphql-sources

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install graphql-sources

## Usage

### Loading `has_one` Associations

```ruby
class Profile < ActiveRecord::Base
  belongs_to :user
end
```

```ruby
class User < ActiveRecord::Base
  has_one :profile
end
```

```ruby
class UserType < GraphQL::Schema::Object
  field :profile, [ProfileType], null: false

  def profile
    dataloader
      .with(GraphQL::Sources::ActiveRecordObject, ::Profile, key: :user_id)
      .load(object.id)
  end
end
```

```sql
SELECT "profiles".*
FROM "profiles"
WHERE "profiles"."user_id" IN (...)
ORDER BY "profiles"."id"
```

### Loading `has_many` Associations

```ruby
class User
  has_many :comments
end
```

```ruby
class Comment
  belongs_to :user
end
```

```ruby
class UserType < GraphQL::Schema::Object
  field :comments, [CommentType], null: false

  def profile
    dataloader
      .with(GraphQL::Sources::ActiveRecordCollection, ::Comment, key: :user_id)
      .load(object.id)
  end
end
```

```sql
SELECT "comments".*
FROM "comments"
WHERE "comments"."user_id" IN (...)
ORDER BY "comments"."id"
```

### Loading `has_one_attached` Associations

```ruby
class User
  has_one_attached :avatar
end
```

```ruby
class UserType < GraphQL::Schema::Object
  field :avatar, AttachedType, null: false

  def avatar
    dataloader
      .with(GraphQL::Sources::ActiveStorageHasOneAttached, :avatar)
      .load(object)
  end
end
```

### Loading `has_many_attached` Associations

```ruby
class User
  has_many_attached :photos
end
```

```ruby
class UserType < GraphQL::Schema::Object
  field :photos, [AttachedType], null: false

  def photos
    dataloader
      .with(GraphQL::Sources::ActiveStorageHasOneAttached, :photos)
      .load(object)
  end
end
```

### Loading Counts

```ruby
class Like
  belongs_to :post
end
```

```ruby
class Post
  has_many :likes
end
```

```ruby
class PostType < GraphQL::Schema::Object
  field :likes, Integer, null: false

  def comments
    dataloader
      .with(GraphQL::Sources::ActiveRecordCount, ::Like, key: :post_id)
      .load(object.id)
  end
end
```

```sql
SELECT "likes"."post_id", COUNT(*)
FROM "likes"
WHERE "likes"."post_id" IN (1, 2, 3, ...)
GROUP BY "likes"."post_id"
```

## Status

[![CircleCI](https://circleci.com/gh/ksylvest/graphql-sources.svg?style=svg)](https://circleci.com/gh/ksylvest/rhino)
[![Maintainability](https://api.codeclimate.com/v1/badges/bc301cb72712637e67dd/maintainability)](https://codeclimate.com/github/ksylvest/graphql-sources/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/bc301cb72712637e67dd/test_coverage)](https://codeclimate.com/github/ksylvest/graphql-sources/test_coverage)

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
