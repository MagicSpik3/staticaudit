create_master_v1 <- function(path){
  df <- haven::read_sav(path)
  colnames(df) <- tolower(colnames(df))
  df <- df |> 
    tidytable::mutate(across(
      where(is.numeric) & !c(area, address, hhold, person),
      ~ item_non_response(.)))
  df
}
