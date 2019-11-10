# Aim: to show how mode split at a city level can be estimated

# vignette("e4mprobit")

library("mlogit")
data("Mode", package="mlogit")
head(Mode, 2)
Mo = mlogit.data(Mode, choice = 'choice', shape = 'wide', varying = c(2:9))
p1 = mlogit(choice ~ cost + time, Mo, seed = 20, R = 100, probit = TRUE)
p1
m_test = Mode[1, ]
m_test$cost.car = 9
m_test$cost.carpool = 0.1

Mo1 = mlogit.data(m_test, choice = 'choice', shape = 'wide', varying = c(2:9))
predict(p1, Mo1)

m_test$cost.car = 2
m_test$cost.carpool = 5

Mo1 = mlogit.data(m_test, choice = 'choice', shape = 'wide', varying = c(2:9))
predict(p1, Mo1)


