# Classification of Take-out Orderers by Expectation Maximization Algorithm.

* Topic: Research on UCAS students' online take-out ordering

* Group members: 王华强、刘蕴哲、杨钊、高云聪

***
## Introduction

Recently, rapid development in the field of mobile Internet have heightened the need for take-out. The Big Data technology and the Mobile Internet technology have seen the fast growth  of take-out market(iiMedia Research, 2016). According to the report from Institute of Frontier Industry Research in 2016, the whole market of online take-out selling will reach at 118 billion yuan per year at the end of 2017. We can safely predict that the take-out market will grow even faster in the following few years (iiMedia Research, 2017). In the meantime, college students make a cosiderable contribution to the hypergrowth of take-out. TrustData found a strong relationship between the number of take-out orders and the number of universities, which also suggests that students consumed a large number of online take-out(TrustData, 2017). However, no math model of university students' take-out ordering behavior pattern has been developed by now. Despite many reports focusing on the whole market of take-out, none of them is detailed enough to show the purchasing behavior pattern on campus. There have also been reports made by other universities’ students which are based on rather casual questionnaires and guesses (Li, 2015). These reports failed to reveal the behavior pattern of online take-out ordering.

This paper seeks to find out the behavior pattern of online take-out ordering and the relationships among all these factors by analyisng the data obtained from UCAS’s Yuquan campus. After the analysis of the results of 107 questionnaires, the result clearly showed two different behavior patterns of take-out orderers. Based on the analysis, we provide a method to conjecture one's take-out ordering behavior according to his daily routine. The method enables us to provide useful suggestions for the university's logistics department and take-out providers.

## Methods

Large amount of data is required to support a latent behavior pattern.  Consequently, an efficient way of data collecting is required.  Finally, we adopted the method of online questionnaire.  An online questionnaire enables us to directly obtain digital data through the backstage, which is convenient to manipulate especially when the sample scale is large.  

In order to obtain an overall conclusion, we tried to cover a wide range of questions in the questionnaire.  However, a redundant questionnaire is time-consuming and will lead to a significantly low recovering rate.  Consequently, the quantity of questions is supposed to be limited.  The contents of the questionnaire are listed as follows:

1.	Online ordering frequency
2.	Online ordering time preference
3.	Online ordering platform
4.	Online ordering price range and the proportion to life expenses
5.	Main factors considered in online ordering
6.	Main reasons for choosing takeout
7.	Degree of concern about takeout hygiene
8.	Parents' attitude towards takeout
9.	Students’ general evaluations of takeout.
10.	Conditions in which the students will give up ordering online 

The options were carefully set that we took many factors into consideration.  Take the question about online ordering price range as an example.  The lowest discount price of most stores is set in the range of 20-30 yuan in eleme app.  A part of the students possibly order what they want only.  However, most of the students, in order to use the red envelopes, have to purchase food valued over 35 yuan.  The final cost will consequently exceed 25 yuan.  As a result, we set the price range as below: <15 rmb/order”, ”15-25 rmb/order”, ”25-50rmb/order”, ”>50 rmb/order”.  These details enable us to obtain well-directed data.

The object of the survey is the undergraduates in the Yuquanlu campus of the University of Chinese Academy of Sciences (hereinafter referred to as UCAS).  In order to include a large number of participants, we posted our online questionnaire on major social platforms including QQ and WeChat.  We finally received in total 105 sets of questionnaire answers, of which 103 are valid.  2 responses were eliminated because though the participants confirmed that they ordered take-out, they called for deliveries at a frequency of null.  Though the rest of answers are valid, drawbacks still exist.  Due to the feature of online questionnaire, we have no access to the number of people who have viewed the questionnaire.  As a result, the recovery rate of the questionnaire remains unknown.  In addition, the title of the questionnaire is Take-out in UCAS.  We suspect that undergraduates who never conducted online ordering probably overlooked the questionnaire.  In conclusion, it is not a perfect sampling of undergraduates in UCAS and we are not able to conclude the ratio of take-out users according to the data as intended.  In addition, we have to admit that the meaning of options in a few questions were not explicit enough for participants.  They could be variously interpreted, which brought us some problems.  We also found that some of the questions were poorly related to each other.  As a result, it was difficult for us to conclude rules according to the data.  We then adopted a powerful tool named EM algorithm.

The Expectation–Maximization (EM) algorithm is able to rule out redundant information.  We expected to explore possible relationships among various factors.  EM algorithm is an iterative method to find maximum likelihood or maximum a posteriori (MAP) estimates of parameters in statistical models, where the model depends on unobserved latent variables (Wikipedia).  It conducts an expectation (E) step and a maximization (M) step in turn repeatedly.  To make it simple, we can describe the expectation (E) step as a step to guess the result, while maximization (M) step is a step to check and correct the guess with the data.  Through the process, it is able to find a latent pattern and determine the distribution of variables in the pattern. 

<!-- ### 1. Questionnaire design

We adopt the method of online questionnaire. The object of the survey is all the undergraduates in the Yuquanlu campus of University of Chinese Academy of Sciences (hereinafter referred to as UCAS).  

We posted our online questionnaire on all the major social platforms. It is convenient to collect the data through the backstage especially when the sample scale is large.

The contents of the questionnaire are listed as follows:    

#### 1. Consumption situation on online ordering

1. Online ordering frequency: the options were set as follows: ”never”, ”no more than three times a month”, ”several times a week”, ”almost once a day”, ”two or three times a day”.
1. Online ordering time: the options were set as follows: ”mostly on weekends”, ”mostly on weekdays”, ”whenever I want”.
1. Online ordering platform: the options included three most commonly used takeout platforms.
1. Online ordering price range: the options were set as follows: ”<15 rmb/share”, ”15-25 rmb/share”, ”25-50rmb/share”,”>50 rmb/share”. 

Take the Eleme app as an example. The lowest discount price of most stores is set in the range of 20-30 yuan. A part of the students possibly order what they want only. However, most of the students, in order to use the red envelopes, have to purchase food valued over 35 yuan. The final cost will consequently exceed 25 yuan. As a result, we set the price range as above. 
#### 2. Influence factors on online ordering

1. The main factors considered in online ordering: we considered subjective needs of consumers and quality of store's service as two major factors. In addition, we provided several other options, “Other-Specify” included.
1. The main reasons for choosing online ordering: we provided following options: ”felt bad about food in canteen“, “felt crowded in canteen”, “got coupons “, ”be recommended by others”, “joined others to obtain a discount”, “missed the meal time”, ”expected for a big meal”, “refused to go out”, “had too much money”, an “Other-Specify” is also included.

#### 3. Other views on takeout

In this part, we investigated the degree of concern about takeout hygiene, the degree of parents' support for children ordering online and students’ general evaluations of takeout. We also added a fill - in question to investigate conditions in which the students will give up ordering online, hoping to collect more information for later analysis.

In our survey, we received totally 105 sets of questionnaire answers, of which 103 are valid.  2 responses were eliminated because though the participants confirmed that they ordered take-out, they called for deliveries at a frequency of null. According to the data, over half of the students had take-out several times a week. A Similar percentage of students mostly had take-out on weekends. The major factor which students considered when ordering online is the price along with the taste. It is partly confirmed by following data. Around sixty percent of students spent 15 to 25 yuan per share. Half of them allocated less than 15 percent of their living expenses to take-out. In addition, both parents and children worried little about take-out hygiene. The reasons why students chose to have take-out are highly diversified.  Poor impression on canteen contributed to the popularity of take-out because over half of the students spoke evilly about the taste of dishes offered in canteen. -->

## Result

### 1. Line of thinking

The analyzation for the gained data can be sorted into four stages. Firstly, the data were manually analyzed to check if some basic rules can be find. Secondly, different algorithms were applied in order to find the suitest one for the following research. In this stage, the EM algorithm was proved to the the best tool. The EM algorithm was then adopted, and the result was checked manually to see if it could be further improved. Finally, the EM algorithm's parameter and the source data were changed according to the result of the last stage, and the result of second trial was taken as the final result. 

### 2. Basic analyzing of the data

We first finished preliminary analysis of the data. Before setting out to find interal relationships among data, we ruled out some invalid information. Some of the questions were not set properly. Consequently, their results have no reference value.

<!-- ![res1.png](res1.png)
_Figure 2.1. Do you order online?_|
-|-

It is a seemingly meaningful result that three fourths of the students order online. However, we conducted the survey with an online questionnaire, which means we have no access to obtain the recovery rate of the questionnaire.  In addition, the title of our questionnaire is Take-out in UCAS.  As a result, undergraduates who never conducted online ordering probably overlooked the questionnaire.  In conclusion, it is not a proper sampling of undergraduates in UCAS.  Consequently, we are not able to conclude the ratio of take-out users according to the answers of our second question. -->

![res2.png](res2.png)
_Figure 2.2. What factors will you consider when choosing take-out?_| 
-|-

The options of the question were not properly set because the meaning of the word preference was not explicit enough for participants. As a result, the fourth option has various interpretations.  In conclusion, the result of the question is invalid strictly.

To cover all possible factors which affect students’ take-out ordering behavior, we set a large number of questions. In addition, some of the questions were poorly related to each other. Yet we cannot just judge them as redundant.  Therefore, it is difficult to conclude rules manually according to the simply-processed data.

### 3. Preliminary analysis

As it is impossible to find latent rules with the simply-processed data, our group chose to adopt machine learning algorithm to analyze these data. Before formally starting mining the data, we did preliminary studies to find a promising direction. For there were many algorithms to choose from, we chose to test each valid algorithm in Weka (Waikato Environment for Knowledge Analysis) using the initial parameter provided by the software. We then compared the results for seek of the best one.

|Algorithm|Bayes-Net|Naive-Bayes-Net|Logistic|SMO|DecisionTable|J48|EM|
|-|-|-|-|-|-|-|-|
|Kappa|0.0382|0.0243|-0.0724|0.1181|0.0003|0.0709|x|

result|
-|-

The result above revealed that all the classification algorithm provided results with kappa less than 0.2. Some of them even had negative kappa value which means the results were worse than that from random classification. The same circumstance repeated when we tried the association algorithms. Surprisingly, the EM algorithm, though failing to offer a clear classification for specially appointed attribute (hence its kappa could not be calculated), did provide meaningful findings with disordered data. As a result, the EM algorithm was adopted for further mining job. 

<!-- ### 4. Basic analyzation -->

### 4. Applying the Expectation Maximization Algorithm

The EM Algorithm, as its name suggests, is an algorithm used for classification of a known data set which has max expectation (Do, C. B., & Batzoglou, S. (2008)). In this experiment, we used the EM algorithm included in Weka (Waikato Environment for Knowledge Analysis) by the University of Waikato.

At the very beginning, we applied the EM algorithm directly to the pre-processed data, the first trial used the following parameters:

```
weka.clusterers.EM -I 100 -N -1 -X 10 -max -1 -ll-cv 1.0E-6 -ll-iter 1.0E-6 -M 1.0E-6 -K 10 -num-slots 1 -S 100
```

The head of the results are listed as follow. 

```
EM
Number of clusters selected by cross validation: 2
Number of iterations performed: 14
                               Cluster
Attribute                            0       1
                                (0.56)  (0.44)
===============================================
WHERE-ELM
  yes                           29.1075 35.8925
  no                             17.871   1.129
  [total]                       46.9785 37.0215
WHERE-BD
  yes                            9.6428 16.3572
  no                            37.3356 20.6644
  [total]                       46.9785 37.0215
  ......
  (23 attributes unlisted)
```
_Table 4.1 Head of the first test's result_|
-|-

The result includes a large quantaty of data, with which we failed to concluded significant results. However, the EM algorithm did succeed in seperating raw data into two different sets with similar size. For most of the attributes in the result list, the difference was not obvious. However, for some of the binary attributes, the classification matrix showed that the 2 sets generated by this algorithm had huge difference in these attributes. We picked out these attributes as following:

```
Attributes picked out in the result of EM

WHY-TOGETHER
  no                    28.7305 32.2695
  yes                   17.9241  5.0759
  [total]               46.6546 37.3454
WHY-OUTOFLUNCHTIME
  yes                   29.7774 12.2226
  no                    16.8772 25.1228
  [total]               46.6546 37.3454
AT_TIME
  c                     19.2888 27.7112
  a                     25.4579  9.5421
  b                      2.9078  1.0922
  [total]               47.6546 38.3454
WHY-AWFULCANTEEN
  no                    25.9073  5.0927
  yes                   20.7473 32.2527
  [total]               46.6546 37.3454
WHY-CROWDEDCANTEEN
  no                    35.1047 10.8953
  yes                   11.5498 26.4502
  [total]               46.6546 37.3454

......
```
_Table 4.2 Attributes picked out_|
-|-

The attributes listed above had obvious difference between the two groups. Since this was only the preliminary result generated by the EM algorithm with the initial parameters, we could claim that it could still be improved. 

### 5. Improve the Algorithm: Further Data Process

#### 5-1. General View

In the first trial, we took 25 factors into consideration. However, according to the result, only some of them showed great differences in the two sets. While the other attributes had no significant contribution to the classification. For instance:

```
WHY-WANNAEATBETTER (The participant choose taken-out for he wants to eat better)
  no                    31.5739 25.4261
  yes                   16.4403 10.5597
  [total]               48.0142 35.9858

WHY-AWFULCANTEEN (The participant choose taken-out for he can not bear the canteen)
  no                    25.9073  5.0927
  yes                   20.7473 32.2527
  [total]               46.6546 37.3454
```

From the matrix above, we can conclude that the two groups of participants share similar distribution of the percentage of people choosing take-out for better meals. However, the two groups differ significantly in the attitudes towards the school canteen. In the left group, only half of its members claim that the canteen is awful, while in the other group, more than 80% of participants hold the idea that the canteen is unbearable. In fact, there are 15 attributes differ significantly between the two groups.

Yet it was only the first trial with the raw data and initial parameters. Further process of these attributes would undoubtly improve the outcome. We then took two measures: deleting useless data and merging similar options. 

#### 5-2. Delete Useless Attributes

For some of the attributes, the choices gathered together in single choices. 

![attr](style.png)

_Figure 5.1. Pre-processed data_|
-|-

For instance, in attributes like WHY-MATESUGGEST (which asked if the responder choose to order take-out because of other peoples' suggest), is greatly imbalanced. As the graph suggests, few participants order take-out because others' suggest. In this situation, this attribute can be deleted in the next EM test, for it can hardly provide any useful information for classification, so according to the principle of EM. , deleting them will not harm the general result. Also, if left untouched, these imbalance attribute will introduce more Randomness into the result of EM. Attributes with similar conditions are:

```
WHY-IAMRICH
CHOOSE-ELSE
WHERE-ELSE
WHY-MATESSUGGEST
WHY-TASTE
CHOOSE-SERVICE
WHY-NOOUTDOOR
```
_Table 5.2.  Attributes chosen_|
-|-
These attributes were removed before the next turn of EM began.

<!-- For we have found that other attributes showed no great difference in the two groups, -->

#### 5-3. Merge Similar options

Not only the common pattern will make blur of the results, but also one question with many different options can also add up to the difficulty of data analyze. To avoid this, we chose to merge the options of such questions.

Take the score for canteen attribute for instance. In the questionnaire, the question asking participants to make a score foe the canteen was designed as a Likek scale (Likert summated rating scale) to make out the difference between the slight difference in attitudes towards the canteen. Unfortunately, this design also made the result too complicated so that the algorithm could not use this key to do classify works correctly. To be more specific, for instance, the algorithm does not know the relationship between "dislike" and "hate", hence it algorithm considered these 2 options as 2 completely different emotions, while in fact they both represent negative emotions, only to be different in levels. Therefore, merge such options together as negative attitude can greatly improve the outcome of the algorithm (林东方, 2012).

Attributes with merged options are listed below. These attributes used to have no less than 5 options, while they have no more than 3 options after merging.
```
SCORE-CANTEEN
  neutral               33.9477 26.0523
  positive               10.721   5.279
  negative               2.9859  7.0141
  [total]               47.6546 38.3454
SCORE_TAKEOUT2s
  neutral               29.6341 19.3659
  positive              17.0205 17.9795
  [total]               46.6546 37.3454
``` 
_Table 5.3. Attributes with merged options_|
-|-

The same method was also applied to "PRICE", "AT-TIME", "FREQUENCY" and "SPEND-PERCENTAGE".

### 6. Final Result by Second Trail

After processing the data, the EM algorithm was applied once again to the adjusted data, which lead to the final result as following:

```
*Clustering model (full training set)

EM
==

Number of clusters selected by cross validation: 2
Number of iterations performed: 20

                       Cluster
Attribute                    0       1
                        (0.58)  (0.42)
=======================================

WHY-CROWDEDCANTEEN
  no                    36.4262  9.5738
  yes                    11.588  26.412
  [total]               48.0142 35.9858
AT_TIME
  c                     20.3408 26.6592
  a                     25.7288  9.2712
  b                      2.9446  1.0554
  [total]               49.0142 36.9858

......

SCORE-CANTEEN
  neutral               35.1152 24.8848
  positive              10.8694  5.1306
  negative               3.0295  6.9705
  [total]               49.0142 36.9858
SCORE_TAKEOUT2s
  neutral               30.8225 18.1775
  positive              17.1917 17.8083
  [total]               48.0142 35.9858

Time taken to build model (full training data) : 0.48 seconds

=== Model and evaluation on training set ===

Clustered Instances

0      45 ( 56%)
1      35 ( 44%)

Log likelihood: -11.44594

``` 
_Table 5.4. Clustering model_|
-|-

**The whole Clustering model is too long to list in paper's main body. Full version of the clustering model can be accessed in Appendix.*

For some of the questions, the raw result was in format like "a, b, c, d, e", their meanings are as following:
```
FREQUENCY
A-（never）
B-（no more than three times a month）
C-（several times a week）
D-（almost once a day）
E-（two or three times a day）

AT-TIME
A-（mostly on weekends）
B-（mostly on weekdays）
C-（whenever I want）

PRICE
A- <15 rmb/order
B- 15-25 rmb/order
C- 25-50 rmb/order
D- >50 rmb/order

SPEND-PERCENTAGE
A- <15%
C- 30%-50%
B- 15%-30%
D- >50%
```
_Table 5.5.  Check list for several questions_|
-|-

<!-- ### 7. Verifying of the final result by EM. -->
Above is the full result generated by EM algorithm. Compared with the first result, this result divided the participants into two groups differ more significantly.

This result can be repeated using the data set with the following commands on Weka:
```
weka.clusterers.EM -I 100 -N -1 -X 10 -max -1 -ll-cv 1.0E-6 -ll-iter 1.0E-6 -M 1.0E-6 -K 10 -num-slots 1 -S 100
```

### 7. Analysis for the Final Result

Combining the result of the EM algorithm and the result of the basic analyzing, we can roughly divide the take-out orderers in UCAS into two groups. Generally, the first group can be described as people who have negative attitudes towards the canteen, most of them highly evaluated take-out, and enjoyed ordering take-out together with their roommates. Meanwhile, most of them also believes that the canteen is too crowded some times.

The other group of people share different characteristic with the first group of people. While half of them claim that they choose take-out because the canteen is too awful (which is far less than the first group, in which almost all the people believes that the awful canteen is the reason for them to order take-out), they order take-out mainly because of they missed the time for lunch or dinner. These people order take-out mainly at the weekends, and they are less likely to share take-out with their friends.

To sum up, the first group of people can be defined as those who do not like the school canteen so that they choose to take take-out, while another group, which is similar in size with the first group, order take-out mainly because they want food out of the meal time and dinner time.

## Discussion

With the method of supervised machine learning, our study summarized the behavior pattern of the UCAS take-out orderers for the first time. 

In the model built by the EM algorithm, we find two kinds of groups with obvious differences in online-ordering behavior. People in one of them are not satisfied with the university canteen. People in the other group order take-out only for sake of its efficiency. Compared with other research on university students' take-out ordering , this research provides a quantified model for take-out ordering, which is more convincing and repeatable. By using this model, we can speculate a person's taken-out ordering behavior pattern with limited information.

Some suggestions can be given from the result of our study:

#### 1. Recommendations for the stores:

Most students are more willing to accept 15-25 yuan / order takeout. Stores can try to keep the profit while controlling the price within the range of 15-25 yuan / single, which might increase the sales. At the same time, the hygiene problem is one of the important areas which students are concerned about. Over 90% of the students worry about the hygiene safety of takeout to varying degrees. Stores should also pay attention to food hygiene and packaging forms in order to provide customers with better dining experience.

#### 2. Recommendations for canteens:

Most of the students give poor evaluation of college cantee, due to poor food taste and crowded environment. The canteen should frequently provide new dishes which prevents students from boredom. The canteen can also lengthen the meal time to meet the needs of more students. In addition, over 40% of the participants said they would give up takeout as long as the canteen improved their food and service. Therefore, the performance of college canteen may even affect the takeout ordering behavior pattern of students.

#### 3. Recommendations for students:

It turns out that over half of the students formed a habit of ordering online, and the major reason for them to choose takeout is laziness: they just don't want to leave the dormitory. We should not only focus on the convenience brought by technology but also notice the latent health risks. A healthy lifestyle requires more exercise instead of lying on the bed.

However, drawbacks of this research do exist. The greatest challenge is from the data we have access to. We suspect that take-out ordering is also related to academic achievement and physical fitness of the orderers. However, for two limitation factors listed as follow, the doubt cannot be discussed in this paper. 

The first limitation is the content of questionnaire. Experience tells us that too many questions will lead to poor recovery rate. In our questionnaire there are already 14 questions. As a result, it is unwise to add any question.

The second limitation is about privacy of participants. For the fact that some participants are not willing to mention their GPA, it is hard to gather data related to academic performance. In addition, it is also impossible to take use of publicized information about grades, because the questionnaire is anonymous.

As a result, the research only focus on take-out ordering behavior itself. We believe that further research on the relationship between take-out ordering and othor factors will lead to more exciting discovery.


## References

<!-- (Not all included...... yet) -->
Do, C. B., & Batzoglou, S. (2008). What is the expectation maximization algorithm?. Nature biotechnology, 26(8), 897.

iiMedia Research. (2016). Research report for Chinese take-out industry(2016).

iiMedia Research. (2017). Research report for Chinese take-out industry(2017). 

Wikipedia. (2017) Expectation–maximization algorithm. [Online] Available from: https://en.wikipedia.org/wiki/Expectation%E2%80%93maximization_algorithm [Accessed: 10th January 2018]

林东方. (2012). 基于EM算法的不完全测量数据的处理方法研究. (Doctoral dissertation, 中南大学).

李鲁静. (2015). 大学生网络外卖消费现状及发展研究. 商场现代化(2), 25-25.

岳佳. (2007). 基于EM算法的模型聚类的研究及应用. (Doctoral dissertation, 江南大学).

赵耀. (2016). 大学生外卖消费现况及其影响因素分析——以安徽财经大学为例. 江苏商论(20), 164-165.


## Appendix  

### Appendix-1    *Full Clustering model**

```
=== Clustering model (full training set) ===

EM
==

Number of clusters selected by cross validation: 2
Number of iterations performed: 20

                       Cluster
Attribute                    0       1
                        (0.58)  (0.42)
=======================================
WHERE-ELM
  yes                   30.3819 34.6181
  no                    17.6323  1.3677
  [total]               48.0142 35.9858
WHERE-BD
  yes                    9.4627 16.5373
  no                    38.5514 19.4486
  [total]               48.0142 35.9858
WHERE-MT
  no                    17.1953 25.8047
  yes                   30.8189 10.1811
  [total]               48.0142 35.9858
FREQUENCY
  c                     17.1175 27.8825
  b                     28.8838  1.1162
  d                      1.0127  6.9873
  e                      1.0013  1.9987
  a                      2.9989  1.0011
  [total]               51.0142 38.9858
AT_TIME
  c                     20.3408 26.6592
  a                     25.7288  9.2712
  b                      2.9446  1.0554
  [total]               49.0142 36.9858
PRICE
  b                      27.734  23.266
  c                     16.2951 10.7049
  a                      3.9873  3.0127
  d                      1.9979  1.0021
  [total]               50.0142 37.9858
SPEND_PERCENTAGE
  a                     40.0709  2.9291
  c                      1.7132 13.2868
  b                      6.2307 18.7693
  d                      1.9994  3.0006
  [total]               50.0142 37.9858
CHOOSE-PRICE
  yes                   35.7326 31.2674
  no                    12.2816  4.7184
  [total]               48.0142 35.9858
CHOOSE-PERSONALFAVOR
  yes                   27.6935 21.3065
  no                    20.3207 14.6793
  [total]               48.0142 35.9858
WHY-AWFULCANTEEN
  no                     26.908   4.092
  yes                   21.1061 31.8939
  [total]               48.0142 35.9858
WHY-CROWDEDCANTEEN
  no                    36.4262  9.5738
  yes                    11.588  26.412
  [total]               48.0142 35.9858
WHY-HAVEDISCOUNT
  yes                    18.976  15.024
  no                    29.0382 20.9618
  [total]               48.0142 35.9858
WHY-TOGETHER
  no                    29.8723 31.1277
  yes                   18.1419  4.8581
  [total]               48.0142 35.9858
WHY-OUTOFLUNCHTIME
  yes                   30.1958 11.8042
  no                    17.8183 24.1817
  [total]               48.0142 35.9858
WHY-WANNAEATBETTER
  no                    31.5739 25.4261
  yes                   16.4403 10.5597
  [total]               48.0142 35.9858
SCORE-CANTEEN
  neutral               35.1152 24.8848
  positive              10.8694  5.1306
  negative               3.0295  6.9705
  [total]               49.0142 36.9858
SCORE_TAKEOUT2s
  neutral               30.8225 18.1775
  positive              17.1917 17.8083
  [total]               48.0142 35.9858

Time taken to build model (full training data) : 0.48 seconds

=== Model and evaluation on training set ===

Clustered Instances

0      45 ( 56%)
1      35 ( 44%)

Log likelihood: -11.44594

``` 
_Table A-1. Full Clustering model_|
-|-