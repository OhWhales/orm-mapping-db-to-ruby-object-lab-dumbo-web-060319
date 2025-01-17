class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = Student.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student 
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
        SELECT *
        FROM students
    SQL
    DB[:conn].execute(sql).map do |person|
      self.new_from_db(person)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL 
      SELECT *
      FROM students 
      WHERE name = ?
      LIMIT 1 
    SQL
    x = DB[:conn].execute(sql, name)
    x=x[0]
    a = Student.new 
    a.id = x[0]
    a.name = x[1]
    a.grade = x[2]
    a
  end



  def self.all_students_in_grade_9
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 9
    SQL

    DB[:conn].execute(sql).map do |student|
      self.new_from_db(student)
    end
  end
  
  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade < 12 
    SQL
    DB[:conn].execute(sql).map do |student|
      self.new_from_db(student)
    end
  end

  def self.first_X_students_in_grade_10(num)
    sql = <<-SQL
      SELECT *
      FROM students 
      WHERE grade=10 
      LIMIT ?
    SQL
    DB[:conn].execute(sql,num).map do |s|
      self.new_from_db(s)
    end
  end

  def self.first_student_in_grade_10 
    sql = <<-SQL
      SELECT *
      FROM students 
      WHERE grade = 10 
      LIMIT 1
    SQL
    DB[:conn].execute(sql).map do |s|
      self.new_from_db(s)
    end.first
  end
  # def self.first_student_in_grade_10
  #   sql = <<-SQL
  #     SELECT *
  #     FROM students
  #     WHERE grade = 10
  #     ORDER BY students.id LIMIT 1
  #   SQL

  #   DB[:conn].execute(sql).map do |row|
  #     self.new_from_db(row)
  #   end.first
  # end

  def self.all_students_in_grade_X(arg)
    sql = <<-SQL
      SELECT *
      FROM students 
      WHERE grade = ? 
    SQL
    DB[:conn].execute(sql, arg).map do |s|
      self.new_from_db(s)
    end
  end



  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
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
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
