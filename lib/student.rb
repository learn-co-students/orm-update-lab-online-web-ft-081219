require_relative "../config/environment.rb"
require "pry"
class Student
  attr_accessor :name, :grade, :id
  
  def initialize(name, grade, id=nil)
    @name = name 
    @grade = grade 
    @id = id 
  end 
  
  def self.create_table
    sql = <<-SQL 
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT, 
        grade TEXT
        )
    SQL
    DB[:conn].execute(sql)
  end 
  
  def self.drop_table
    sql = <<-SQL
      DROP TABLE IF EXISTS students
    SQL
    DB[:conn].execute(sql)
  end 
  
 def save
    if self.id
      self.update
    else
      sql = <<-SQL 
        INSERT INTO students (name, grade)
        VALUES (?,?)
      SQL

      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
      end
    end 

    def self.create(name, grade)
    students = Student.new(name, grade)
    students.save
    students
  end
  
  def self.new_from_db(row)
    # binding.pry
    id = row[0]
    name = row[1]
    grade = row[2]
    self.new(name, grade, id)
  end 
  
  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ?"
    DB[:conn].execute(sql, name).map { |row| new_from_db(row) }.first
  end
  
    def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end
end


