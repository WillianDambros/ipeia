
# https://www.ipeadata.gov.br/api/
 
# https://www.ipeadata.gov.br/api/odata4/Territorios                        # 51

endereco_metadados <- "https://www.ipeadata.gov.br/api/odata4/Metadados"

metadados <- httr::GET(endereco_metadados)

metadados <- httr::content(metadados, "text", encoding = "UTF-8") |> 
  jsonlite::fromJSON(simplifyDataFrame = FALSE)


metadados |> dplyr::glimpse()

resumo_dados_extraidos <- metadados$value |>
  purrr::map(~ .x[c("SERCODIGO", "SERNOME", "FNTSIGLA")]) |>
  dplyr::bind_rows()

resumo_dados_extraidos |> dplyr::filter(FNTSIGLA == "IPEA") |> print(n = 245)

resumo_dados_extraidos |> dplyr::filter(FNTSIGLA == "Outras fontes") |> print(n = 30)


resumo_dados_extraidos |>
  dplyr::filter(
    FNTSIGLA == "IPEA",
    stringr::str_detect(SERNOME, stringr::regex("IDHM", ignore_case = TRUE))
  ) |>
  print(n = 245)


?sprintf()

# 1. Monta a URL com o código da série
codigo_serie <- "IDHM"
url_valores <- sprintf(
  "http://www.ipeadata.gov.br/api/odata4/ValoresSerie(SERCODIGO='%s')",
  codigo_serie
)

# 2. Faz a requisição
resposta <- httr::GET(url_valores)

# 3. Converte o conteúdo JSON para uma lista/data frame
dados_idhm <- httr::content(resposta, "text", encoding = "UTF-8") |>
  jsonlite::fromJSON(simplifyDataFrame = TRUE)

# 4. Extrai o data frame de valores (o JSON retorna em `$value`)
valores_idhm <- dados_idhm$value

# 5. (Opcional) Visualiza
valores_idhm |> dplyr::glimpse()

valores_idhm |> print()


# https://www.ipeadata.gov.br/api/odata4/ValoresSerie(SERCODIGO='IDHM') # não consta os municipios


# https://www.ipeadata.gov.br/api/odata4/ValoresSerie(SERCODIGO='ADH_IDHM')?$filter=NIVNOME%20eq%20%27Munic%C3%ADpios%27%20and%20startswith(TERCODIGO,%2751%27)