module Ladb::OpenCutList::Kuix

  class GridLayout

    def initialize(num_cols = 1, num_rows = 1, horizontal_gap = 0, vertical_gap = 0)
      @num_cols = [ num_cols.to_i, 1 ].max
      @num_rows = [ num_rows.to_i, 1 ].max
      @horizontal_gap = horizontal_gap.to_i
      @vertical_gap = vertical_gap.to_i
    end

    def measure_prefered_size(target, prefered_width, size)
      _compute(target, prefered_width, size, false)
    end

    def do_layout(target)
      _compute(target, target.bounds.width, nil, true)
    end

    # -- Internals --

    def _compute(target, preferred_width, size, layout)

      insets = target.insets
      available_width = preferred_width - insets.left - insets.right
      available_height = target.bounds.height - insets.top - insets.bottom

      total_horizontal_gap = @horizontal_gap * (@num_cols - 1)
      total_vertical_gap = @vertical_gap * (@num_rows - 1)

      cell_width = (available_width - total_horizontal_gap) / @num_cols
      cell_height = (available_height - total_vertical_gap) / @num_rows

      col = 0
      row = 0
      prefered_cell_width = 0
      prefered_cell_height = 0

      # Loop on children
      widget = target.child
      until widget.nil?
        if widget.visible?

          if layout
            widget.bounds.set(
              col * (cell_width + @horizontal_gap),
              row * (cell_height + @vertical_gap),
              cell_width,
              cell_height
            )
            widget.do_layout
          else
            prefered_size = widget.get_prefered_size(available_width)
            prefered_cell_width = [ prefered_cell_width, prefered_size.width ].max
            prefered_cell_height = [ prefered_cell_height, prefered_size.height ].max
          end

          col += 1
          if col >= @num_cols
            col = 0
            row += 1
            if row >= @num_rows
              break
            end
          end

        end
        widget = widget.next
      end

      unless layout
        size.set(
          insets.left + [ target.min_size.width, prefered_cell_width * @num_cols + total_horizontal_gap ].max + insets.right,
          insets.top + [ target.min_size.height, prefered_cell_height * @num_rows + total_vertical_gap ].max + insets.bottom
        )
      end

    end

  end

end