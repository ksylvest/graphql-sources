# frozen_string_literal: true

module GraphQL
  module Sources
    # A class for loading an ActiveRecord association.
    #
    # @example `has_and_belongs_to_many`
    #
    #   class Student
    #     has_and_belongs_to_many :courses
    #   end
    #
    #   class Course
    #     has_and_belongs_to_many :students
    #   end
    #
    #   class StudentType < GraphQL::Schema::Object
    #     field :courses, [CourseType], null: false
    #
    #     # @return [Array<Course>]
    #     def courses
    #       # SELECT "courses_students".* FROM "courses_students" WHERE "courses_students"."student_id" = IN (...)
    #       # SELECT "courses".* FROM "courses" WHERE "courses"."id" IN (...)
    #       dataloader
    #         .with(GraphQL::Sources::ActiveRecordAssociation, :courses)
    #         .load(object)
    #     end
    #   end
    #
    #   class CourseType < GraphQL::Schema::Object
    #     field :students, [StudentType], null: false
    #
    #     # @return [Array<Student>]
    #     def students
    #       # SELECT "courses_students".* FROM "courses_students" WHERE "courses_students"."course_id" = IN (...)
    #       # SELECT "students".* FROM "students" WHERE "students"."id" IN (...)
    #       dataloader
    #         .with(GraphQL::Sources::ActiveRecordAssociation, :students)
    #         .load(object)
    #     end
    #   end
    #
    #
    # @example `has_many` / `belongs_to`
    #
    #   class User
    #     has_many :comments
    #   end
    #
    #   class Comment
    #     belongs_to :user
    #   end
    #
    #   class UserType < GraphQL::Schema::Object
    #     field :comments, [CommentType], null: false
    #
    #     # @return [Array<Comment>]
    #     def comments
    #       # SELECT "comments".* FROM "comments" WHERE "comments"."user_id" = IN (...)
    #       dataloader
    #         .with(GraphQL::Sources::ActiveRecordAssociation, :comments)
    #         .load(object)
    #     end
    #   end
    #
    #   class CommentType < GraphQL::Schema::Object
    #     field :user, UserType, null: false
    #
    #     # @return [User]
    #     def user
    #       # SELECT "users".* FROM "users" WHERE "users"."id" IN (...)
    #       dataloader
    #         .with(GraphQL::Sources::ActiveRecordAssociation, :user)
    #         .load(object)
    #     end
    #   end
    #
    # @example `has_one` / `belongs_to`
    #
    #   class User
    #     has_one :profile
    #   end
    #
    #   class Profile
    #     belongs_to :user
    #   end
    #
    #   class UserType < GraphQL::Schema::Object
    #     field :profile, ProfileType, null: false
    #
    #     # @return [Profile]
    #     def profile
    #       # SELECT "profiles".* FROM "profiles" WHERE "profiles"."user_id" = IN (...)
    #       dataloader
    #         .with(GraphQL::Sources::ActiveRecordAssociation, :profile)
    #         .load(object)
    #     end
    #   end
    #
    #   class ProfileType < GraphQL::Schema::Object
    #     field :user, UserType, null: false
    #
    #     # @return [User]
    #     def user
    #       # SELECT "users".* FROM "users" WHERE "users"."id" IN (...)
    #       dataloader
    #         .with(GraphQL::Sources::ActiveRecordAssociation, :user)
    #         .load(object)
    #     end
    #   end
    class ActiveRecordAssociation < GraphQL::Dataloader::Source
      # @param association [Symbol] an association to use for loading (e.g. :user)
      def initialize(association)
        super()
        @association = association
      end

      # @param records [Array<ActiveRecord::Base>] an array of records
      def fetch(records)
        preloader = ActiveRecord::Associations::Preloader.new(records: records, associations: [@association])
        preloader.call

        records.map { |record| record.association(@association).target }
      end
    end
  end
end
