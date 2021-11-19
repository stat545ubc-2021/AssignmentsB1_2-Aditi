test_that("Function dplyr_bundle outputs a tibble", {
  #creating a simple input data to test function
  input <- data.frame(x = c("a","a","a", "b", "b","b","c","c","c"),
                      y = c(1,NA,3,NA,5,7,9,NA,11))
  #testing that the output is a tibble
  expect_s3_class(dplyr_bundle(input, group = x, summary = y), "tbl")})

test_that("Incorrect column types throw an error.", {
  #testing that providing character column for numeric calculations will throw an error
  expect_error(dplyr_bundle(datateachr::apt_buildings, group = property_type, summary = facilities_available))
  expect_error(dplyr_bundle(palmerpenguins::penguins, group = species, summary = island))
})

test_that("A column of only NAs for numeric variable throws an error", {
  input <- data.frame(x = c("a","a","a", "b", "b","b","c","c","c"),
                      y = c(NA,NA,NA,NA,NA,NA,NA,NA,NA))
  expect_error(grouping_summarising(input, group = x, summary = y))
})
