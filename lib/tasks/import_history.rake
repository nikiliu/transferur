namespace :import_history do
  FIRST_ROW          = 2
  LAST_ROW           = 769
  INTERNATIONAL_COL  = 2
  SCHOOL_NAME_COL    = 3
  LOCATION_COL       = 4
  LAST_EVAL_DATE_COL = 5
  COURSE_NUM_COL     = 6
  COURSE_NAME_COL    = 7
  UR_COURSE_NUM_COL  = 8
  ACCEPTABLE_COL     = 9
  REASONS_COL        = 10

  task :populate do
    history = read_spreadsheet()

    # Iterate through each entry
    for i in FIRST_ROW..LAST_ROW
      puts history.cell(i, SCHOOL_NAME_COL)
    end
  end

  # Returns parsed Excel file (using Roo gem)
  def read_spreadsheet
    history               = Roo::Excel.new("import/transfer_credit_history.xls")
    history.default_sheet = history.sheets.first
    history
  end
end
