# GraphQL::Sources

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add graphql-sources

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install graphql-sources

The `GraphQL::Dataloader` plugin must be installed in the schema:

```ruby
class AppSchema < GraphQL::Schema
  use GraphQL::Dataloader
  # ...
end
```

## Usage

### Loading `belongs_to` / `has_many` Associations

```ruby
class Purchase < ActiveRecord::Base
  belongs_to :customer
end
```

```ruby
class Customer < ActiveRecord::Base
  has_many :purchases
end
```

```ruby
class PurchaseType < GraphQL::Schema::Object
  field :customer, CustomerType, null: false

  # @return [Customer]
  def customer
    # SELECT * FROM "customers" WHERE "customers"."id" IN (...)
    dataloader
      .with(GraphQL::Sources::ActiveRecordAssociation, :customer)
      .load(object)
  end
end
```

```ruby
class CustomerType < GraphQL::Schema::Object
  field :purchases, [PurchaseType], null: false

  def purchases
    # SELECT * FROM "customers" WHERE "customers"."id" IN (...)
    dataloader
      .with(GraphQL::Sources::ActiveRecordAssociation, :purchases)
      .load(object)
  end
end
```

### Loading `belongs_to` / `has_one` Associations

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
class ProfileType < GraphQL::Schema::Object
  field :user, [UserType], null: false

  # @return [User]
  def user
    # SELECT * FROM "users" WHERE "users"."id" IN (...)
    dataloader
      .with(GraphQL::Sources::ActiveRecordAssociation, :user)
      .load(object)
  end
end
```

```ruby
class UserType < GraphQL::Schema::Object
  field :profile, [ProfileType], null: false

  # @return [Profile]
  def profile
      # SELECT * FROM "profiles" WHERE "profiles"."id" IN (...)
    dataloader
      .with(GraphQL::Sources::ActiveRecordAssociation, :profile)
      .load(object)
  end
end
```

### Loading `has_and_belongs_to_many` Associations

```ruby
class Student
  has_and_belongs_to_many :courses
end
```

```ruby
class Course
  has_and_belongs_to_many :students
end
```

```ruby
class StudentType < GraphQL::Schema::Object
  field :courses, [CourseType], null: false

  # @return [Array<Course>]
  def courses
    # SELECT * FROM "courses_students" WHERE "courses_students"."student_id" = IN (...)
    # SELECT * FROM "courses" WHERE "courses"."id" IN (...)
    dataloader
      .with(GraphQL::Sources::ActiveRecordAssociation, :courses)
      .load(object)
  end
end
```

```ruby
class CourseType < GraphQL::Schema::Object
  field :students, [StudentType], null: false

  # @return [Array<Student>]
  def students
    # SELECT * FROM "courses_students" WHERE "courses_students"."course_id" = IN (...)
    # SELECT * FROM "students" WHERE "students"."id" IN (...)
    dataloader
      .with(GraphQL::Sources::ActiveRecordAssociation, :students)
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
      .with(GraphQL::Sources::ActiveStorageHasManyAttached, :photos)
      .load(object)
  end
end
```

### Loading ActiveRecord Object / ActiveRecord Collection

```ruby
class Event < ActiveRecord::Base
  belongs_to :device
end
```

```ruby
class Device < ActiveRecord::Base
  has_many :events
end
```

```ruby
class EventType < GraphQL::Schema::Object
  field :device, DeviceType, null: false

  # @return [Device]
  def device
    # SELECT * FROM "devices" WHERE "devices"."id" IN (...)
    dataloader
      .with(GraphQL::Sources::ActiveRecordObject, ::Device, key: :id)
      .load(object.device_id)
  end
end
```

```ruby
class DeviceType < GraphQL::Schema::Object
  field :events, [EventType], null: false

  def events
    # SELECT * FROM "events" WHERE "events"."device_id" IN (...)
    dataloader
      .with(GraphQL::Sources::ActiveRecordCollection, ::Event, key: :device_id)
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

  def likes
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

### Loading Exists

```ruby
class User
  has_many :purchases
end
```

```ruby
class Purchase
  belongs_to :product
  belongs_to :user
end
```

```ruby
class Product
  has_many :purchases
end
```

```ruby
class ProductType
  field :purchased, Boolean, null: false

  def purchased
    dataloader
      .with(GraphQL::Sources::ActiveRecordExists, ::Purchase.where(user: context.user), key: :product_id)
      .load(object.id)
  end
end
```

### Loading with `Rails.cache`

```ruby
class UserType < GraphQL::Schema::Object
  field :location, String, null: false

  def location
    dataloader
      .with(GraphQL::Sources::RailsCache)
      .load(key: "geocode:#{object.latest_ip}", fallback: -> { Geocode.for(object.latest_ip) })
  end
end
```

## Status

[![CircleCI](https://circleci.com/gh/ksylvest/graphql-sources.svg?style=svg)](https://circleci.com/gh/ksylvest/graphql-sources)
[![Maintainability](https://api.codeclimate.com/v1/badges/bc301cb72712637e67dd/maintainability)](https://codeclimate.com/github/ksylvest/graphql-sources/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/bc301cb72712637e67dd/test_coverage)](https://codeclimate.com/github/ksylvest/graphql-sources/test_coverage)

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
