namespace :history do
  require "date"

  # Config
  HISTORY_PATH       = "import/transfer_credit_history.xls"
  FIRST_ROW          = 2
  LAST_ROW           = 769
  SCHOOL_INTL_COL    = 2
  SCHOOL_NAME_COL    = 3
  SCHOOL_LOC_COL     = 4
  COURSE_NUM_COL     = 6
  COURSE_NAME_COL    = 7
  UR_COURSE_NUM_COL  = 8
  ACCEPTABLE_COL     = 9
  REASONS_COL        = 10
  LAST_EVAL_DATE_COL = 5

  # Import all data from the Excel spreadsheet into the database
  task import: :environment do

    # Create the U of R School object and parse Excel spreadsheet
    richmond = create_university_of_richmond()
    history  = read_spreadsheet()

    # Iterate through each row in spreadsheet
    for i in FIRST_ROW..LAST_ROW

      # Parse row information
      transfer_school_hash = parse_transfer_school_info(history, i)
      transfer_course_hash = parse_transfer_course_info(history, i)
      ur_course_hash       = parse_ur_course_info(history, i)
      approved             = (history.cell(i, ACCEPTABLE_COL) == "Y")
      reasons              = history.cell(i, REASONS_COL)
      last_evaluated       = history.cell(i, LAST_EVAL_DATE_COL)

      # Skip if there is no location, reason for rejection, or no course number
      if transfer_school_hash[:location].nil? or
         transfer_course_hash[:course_num].empty? or
         ur_course_hash[:course_num].empty? or
         (!approved and reasons.nil?)
        next
      end

      # Find corresponding rows in database, create if they don't exist
      transfer_school = create_school_if_not_exists(transfer_school_hash)
      transfer_course = create_course_if_not_exists(transfer_school, transfer_course_hash)
      ur_course       = create_course_if_not_exists(richmond, ur_course_hash)

      # Create corresponding transfer request
      ActiveRecord::Base.record_timestamps = false
      transfer_request = TransferRequest.create!(transfer_school_id: transfer_school.id,
                                                 transfer_course_id: transfer_course.id,
                                                 ur_course_id:       ur_course.id,
                                                 approved:           approved,
                                                 reasons:            reasons,
                                                 created_at:         DateTime.now.to_s,
                                                 updated_at:         last_evaluated.to_s)
      puts transfer_request
      ActiveRecord::Base.record_timestamps = true
    end
  end

  # Returns parsed Excel file (using Roo gem)
  def read_spreadsheet
    history               = Roo::Excel.new(HISTORY_PATH)
    history.default_sheet = history.sheets.first
    history
  end

  # Creates and returns the School object corresponding to U of R
  def create_university_of_richmond
    school_name = "University of Richmond"
    school_loc  = "Richmond, VA"
    school_intl = false
    School.create!(name: school_name,
                   location: school_loc,
                   international: school_intl)
  end

  # Return a hash of the transfer school information in the passed row
  def parse_transfer_school_info(history, i)
    {
      name:          history.cell(i, SCHOOL_NAME_COL),
      location:      history.cell(i, SCHOOL_LOC_COL),
      international: history.cell(i, SCHOOL_INTL_COL) == "Y"
    }
  end

  # Return a hash of the transfer course information in the passed row
  def parse_transfer_course_info(history, i)
    {
      name:          history.cell(i, COURSE_NAME_COL).to_s,
      course_num:    history.cell(i, COURSE_NUM_COL).to_s
    }
  end

  # Return a hash of the U of R course information in the passed row
  def parse_ur_course_info(history, i)
    {
      name:          history.cell(i, UR_COURSE_NUM_COL).to_i.to_s,
      course_num:    history.cell(i, UR_COURSE_NUM_COL).to_i.to_s
    }
  end

  # Creates School using given hash if it doesn't exist, returns the School
  def create_school_if_not_exists(hash)
    school = School.find_by(hash)
    school = School.create!(hash) if school == nil
    school
  end

  # Creates Course using given school & hash if it doesn't exist, returns the Course
  def create_course_if_not_exists(school, hash)
    course = school.courses.find_by(hash)
    course = school.courses.create!(hash) if course == nil
    course
  end
end