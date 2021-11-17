#' @title A bundle of dplyr functions
#'
#' @description This function calculates the summary statistics such as mean and range grouped by a categorical variable of your choice for an input dataset.
#' It uses the dplyr functions group_by and summarise to output a tibble or data frame depending on your input data type class.
#'
#' @param input A dataframe or tibble input.
#' @param group A categorical column in the dataframe/tibble that should be used for grouping.
#' @param summary A numerical column for which summary statistics are to be computed.
#' @return A Tibble or dataframe built from a list and containing four columns- categorical variable by which the data is grouped, mean, minimum, maximum computed for a numerical variable.
#' @examples
#' dplyr_bundle(datateachr::vancouver_trees, group = common_name, summary = diameter)
#' dplyr_bundle(palmerpenguins::penguins, group = island, summary = flipper_length_mm)
#' @importFrom dplyr summarise
#' @importFrom rlang enquo
#' @importFrom dplyr group_by
#' @importFrom rlang :=
#' @export
dplyr_bundle = function(input, group, summary){

  group = rlang::enquo(group)
  summary = rlang::enquo(summary)

  check = dplyr::summarise(input,
                    is_text_group = is.character({{ group }}) | is.factor({{ group }}),
                    class_group = class({{ group }}),
                    is_numeric_summary = is.numeric({{ summary }}),
                    class_summary = class({{ summary }})
  )
  if (!check$is_text_group) {
    stop("`x` column must contain text, but is of class: ",
         check$class_group)
  }
  if (!check$is_numeric_summary) {
    stop("`y` column must contain numeric, but is of class: ",
         check$class_summary)
  }

  # Create default column names
  summary_nm = rlang::as_label(summary)

  # Prepend with an informative prefix
  mean = paste0("mean_", summary_nm)
  minimum = paste0("min_", summary_nm)
  maximum = paste0("max_", summary_nm)

  res = input %>%
    dplyr::group_by({{ group }}) %>%
    dplyr::summarise({{ mean }} := mean({{ summary }}, na.rm = TRUE),
              {{ minimum }} := min({{ summary }}, na.rm = TRUE),
              {{ maximum }} := max({{ summary }}, na.rm = TRUE))

  return(res)
}
