Matrix.class_eval do
  def adjugate
    Matrix.Raise ErrDimensionMismatch unless square?
    Matrix.build(row_count, column_count) do |row, column|
      cofactor(column, row)
    end
  end
end