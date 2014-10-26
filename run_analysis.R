subject_test = read.table("subject_test.txt", col.names=c("subject_id"))

subject_test$ID <- as.numeric(rownames(subject_test))

X_test = read.table("X_test.txt")

X_test$ID <- as.numeric(rownames(X_test))

y_test = read.table("y_test.txt", col.names=c("activity_id"))

y_test$ID <- as.numeric(rownames(y_test))

test <- merge(subject_test, y_test, all=TRUE)

test <- merge(test, X_test, all=TRUE)

subject_test = read.table("subject_test.txt", col.names=c("subject_id"))

X_test = read.table("X_test.txt")

X_test$ID <- as.numeric(rownames(X_test))

y_test = read.table("y_test.txt", col.names=c("activity_id"))

y_test$ID <- as.numeric(rownames(y_test))

test <- merge(subject_test, y_test, all=TRUE) 

test <- merge(test, X_test, all=TRUE)

data1 <- rbind(test, test)


features = read.table("features.txt", col.names=c("feature_id", "feature_label"),)

selected_features <- features[grepl("mean\\(\\)", features$feature_label) | grepl("std\\(\\)", features$feature_label), ]

data2 <- data1[, c(c(1, 2, 3), selected_features$feature_id + 3) ]


activity_labels = read.table("activity_labels.txt", col.names=c("activity_id", "activity_label"),)

data3 = merge(data2, activity_labels)


selected_features$feature_label = gsub("\\(\\)", "", selected_features$feature_label)


selected_features$feature_label = gsub("-", ".", selected_features$feature_label)

for (i in 1:length(selected_features$feature_label)) {
    colnames(data3)[i + 3] <- selected_features$feature_label[i]
}
data4 = data3



drops <- c("ID","activity_label")

data5 <- data4[,!(names(data4) %in% drops)]

aggdata <-aggregate(data5, by=list(subject = data5$subject_id, activity = data5$activity_id), FUN=mean, na.rm=TRUE)

drops <- c("subject","activity")

aggdata <- aggdata[,!(names(aggdata) %in% drops)]

aggdata = merge(aggdata, activity_labels)

write.csv(file="submit.csv", x=aggdata)
