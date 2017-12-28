# Classification of take-out orderers by Expectation Maximization Algorithm.

* Topic: Research on UCAS students' online take-out ordering

* Group members: 王华强、刘蕴哲、杨钊、高云聪

---

## Introduction

General statement.
(1 min)

## Methods

1. Questionare Design (1 min) 
1. Pre-experiment (half min) 
1. EM Algorithm (1 min) E-step(guess) and M-step(correct)

## Results

1. Brief analyze of the questionare (1 min)
1. EM result(1st time) and Improvement (1 min)
1. Final result (1 min)

## Discussion

1. Usage & Application
1. Further research (1 min)
1. Summary (1 min)

## Q&A

(1-2 min)

---
## Results

1. EM result(1st time) and Improvement (1 min)

At the very beginning, we apply the EM algorithm directly to the pre-processed data, the first test used the following parameters:

```
weka.clusterers.EM -I 100 -N -1 -X 10 -max -1 -ll-cv 1.0E-6 -ll-iter 1.0E-6 -M 1.0E-6 -K 10 -num-slots 1 -S 100
```
---
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

---

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
FREQUENCY
  c                     15.7128 29.2872
  b                     28.9297  1.0703
  d                      1.0111  6.9889
  e                      1.0024  1.9976
  a                      2.9985  1.0015
  [total]               49.6546 40.3454
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

---
## Final result
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