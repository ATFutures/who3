# Aim: create gantt chart of progress


# get issue data ----------------------------------------------------------

# see https://github.com/jennybc/analyze-github-stuff-with-r
library(gh)
library(dplyr)
library(purrr)

owner = "ATFutures"
repo = "who3"

issue_list = gh("/repos/:owner/:repo/issues", owner = owner, repo = repo, state = "all", .limit = Inf)
(n_iss = length(issue_list))

task_df = issue_list %>%
  {
    data_frame(
      number = map_int(., "number"),
      title = map_chr(., "title"),
      description = map_chr(., "body"),
      state = map_chr(., "state"),
      created_at = map_chr(., "created_at") %>% as.Date()
    )
  }


# code to extract start times ---------------------------------------------

task_df$description[1]
stringi::stri_split_lines(task_df$description[1])
stringi::stri_split_lines(task_df$description[1])[[1]]
stringi::stri_split_lines1(task_df$description[1])

extract_start_date = function(x) {
  
}

issue_df = issue_list %>%
  {
    data_frame(
      number = map_int(., "number"),
      title = map_chr(., "title"),
      description = map_chr(., "body"),
      id = map_int(., "id"),
      state = map_chr(., "state"),
      n_comments = map_int(., "comments"),
      opener = map_chr(., c("user", "login")),
      created_at = map_chr(., "created_at") %>% as.Date()
      )
  }

issue_df
issue_df$description

# more experiments with gh ------------------------------------------------

# repos = gh::gh("/users/:username/repos", username = "ATFutures")
repos = gh::gh("/users/ATFutures/repos")
vapply(repos, "[[", "", "name")

iss_df =
  tibble(
    repo = repos %>% map_chr("name"),
    issue = repo %>%
      map(~ gh(repo = .x, endpoint = "/repos/ATFutures/:repo/issues",
               .limit = Inf))
  )

iss_df %>%
  mutate(n_open = issue %>% map_int(length)) %>%
  select(-issue) %>%
  filter(n_open > 0) %>%
  arrange(desc(n_open)) %>%
  print(n = nrow(.))


