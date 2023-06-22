~~~
<!-- PlutoStaticHTML.Begin -->
<!--
    # This information is used for caching.
    [PlutoStaticHTML.State]
    input_sha = "143c64e5ee2722edde4e17a98b7efb0cf20f10c6b2b90a215fe022ebdbb8a62b"
    julia_version = "1.9.1"
-->
<pre class='language-julia'><code class='language-julia'>using DataFrames, CSV, MLJ, MLJDecisionTreeInterface</code></pre>


<pre class='language-julia'><code class='language-julia'>X_full = CSV.read("data//home-data-for-ml-course//train.csv", DataFrame);</code></pre>


<pre class='language-julia'><code class='language-julia'>X_test_full = CSV.read("data//home-data-for-ml-course//test.csv", DataFrame);</code></pre>


<pre class='language-julia'><code class='language-julia'>describe(X_full);</code></pre>


<pre class='language-julia'><code class='language-julia'>#subset!(X_full, :SalePrice =&gt; ByRow(!=("missing"))) 
# filter SalePrice by row in place</code></pre>


<pre class='language-julia'><code class='language-julia'>dropmissing!(X_full, Cols(:SalePrice));</code></pre>


<pre class='language-julia'><code class='language-julia'>y = X_full.SalePrice;</code></pre>



<div class="markdown"><h2>Fixing data type</h2><h3>convert String type to <em>Int type and  missing</em></h3></div>

<pre class='language-julia'><code class='language-julia'>X_full.LotFrontage = something.(tryparse.(Int, X_full.LotFrontage), missing);</code></pre>


<pre class='language-julia'><code class='language-julia'>X_full.MasVnrArea = something.(tryparse.(Int, X_full.MasVnrArea), missing);</code></pre>


<pre class='language-julia'><code class='language-julia'>X_full.GarageYrBlt = something.(tryparse.(Int, X_full.GarageYrBlt), missing);</code></pre>


<pre class='language-julia'><code class='language-julia'>select!(X_full, Not(:SalePrice)); # drop column SalePrice in Place</code></pre>


<pre class='language-julia'><code class='language-julia'>size(X_full)</code></pre>
<pre class="code-output documenter-example-output" id="var-hash139029">(1460, 80)</pre>

<pre class='language-julia'><code class='language-julia'>X = select(X_full, Cols(x -&gt; eltype(X_full[:, x]) &lt;: Union{Number,Missing})); # </code></pre>


<pre class='language-julia'><code class='language-julia'>X_full</code></pre>
<table><tbody><tr><th></th><th>Id</th><th>MSSubClass</th><th>MSZoning</th><th>LotFrontage</th><th>LotArea</th><th>Street</th><th>Alley</th><th>LotShape</th><th>...</th></tr><tr><td>1</td><td>1</td><td>60</td><td>"RL"</td><td>65</td><td>8450</td><td>"Pave"</td><td>"NA"</td><td>"Reg"</td><td></td></tr><tr><td>2</td><td>2</td><td>20</td><td>"RL"</td><td>80</td><td>9600</td><td>"Pave"</td><td>"NA"</td><td>"Reg"</td><td></td></tr><tr><td>3</td><td>3</td><td>60</td><td>"RL"</td><td>68</td><td>11250</td><td>"Pave"</td><td>"NA"</td><td>"IR1"</td><td></td></tr><tr><td>4</td><td>4</td><td>70</td><td>"RL"</td><td>60</td><td>9550</td><td>"Pave"</td><td>"NA"</td><td>"IR1"</td><td></td></tr><tr><td>5</td><td>5</td><td>60</td><td>"RL"</td><td>84</td><td>14260</td><td>"Pave"</td><td>"NA"</td><td>"IR1"</td><td></td></tr><tr><td>6</td><td>6</td><td>50</td><td>"RL"</td><td>85</td><td>14115</td><td>"Pave"</td><td>"NA"</td><td>"IR1"</td><td></td></tr><tr><td>7</td><td>7</td><td>20</td><td>"RL"</td><td>75</td><td>10084</td><td>"Pave"</td><td>"NA"</td><td>"Reg"</td><td></td></tr><tr><td>8</td><td>8</td><td>60</td><td>"RL"</td><td>missing</td><td>10382</td><td>"Pave"</td><td>"NA"</td><td>"IR1"</td><td></td></tr><tr><td>9</td><td>9</td><td>50</td><td>"RM"</td><td>51</td><td>6120</td><td>"Pave"</td><td>"NA"</td><td>"Reg"</td><td></td></tr><tr><td>10</td><td>10</td><td>190</td><td>"RL"</td><td>50</td><td>7420</td><td>"Pave"</td><td>"NA"</td><td>"Reg"</td><td></td></tr><tr><td>...</td></tr><tr><td>1460</td><td>1460</td><td>20</td><td>"RL"</td><td>75</td><td>9937</td><td>"Pave"</td><td>"NA"</td><td>"Reg"</td><td></td></tr></tbody></table>

<pre class='language-julia'><code class='language-julia'>size(X)</code></pre>
<pre class="code-output documenter-example-output" id="var-hash313044">(1460, 37)</pre>

<pre class='language-julia'><code class='language-julia'>begin
    X_test_full.LotFrontage = something.(tryparse.(Int, X_test_full.LotFrontage), missing);
    X_test_full.MasVnrArea = something.(tryparse.(Int, X_test_full.MasVnrArea), missing);
    X_test_full.GarageYrBlt = something.(tryparse.(Int, X_test_full.GarageYrBlt), missing);
    X_test_full.BsmtFinSF1 = something.(tryparse.(Int, X_test_full.BsmtFinSF1), missing);
    X_test_full.BsmtFinSF2 = something.(tryparse.(Int, X_test_full.BsmtFinSF2), missing);
    X_test_full.BsmtUnfSF = something.(tryparse.(Int, X_test_full.BsmtUnfSF), missing);
    X_test_full.TotalBsmtSF = something.(tryparse.(Int, X_test_full.TotalBsmtSF), missing);
    X_test_full.GarageCars = something.(tryparse.(Int, X_test_full.GarageCars), missing);
    X_test_full.GarageArea = something.(tryparse.(Int, X_test_full.GarageArea), missing);
    X_test_full.BsmtFullBath = something.(tryparse.(Int, X_test_full.BsmtFullBath), missing);
    X_test_full.BsmtHalfBath = something.(tryparse.(Int, X_test_full.BsmtHalfBath), missing);
end</code></pre>
<pre class="code-output documenter-example-output" id="var-hash107111">1459-element Vector{Union{Missing, Int64}}:
 0
 0
 0
 0
 0
 0
 0
 ⋮
 0
 0
 0
 0
 1
 0</pre>

<pre class='language-julia'><code class='language-julia'>X_test_full</code></pre>
<table><tbody><tr><th></th><th>Id</th><th>MSSubClass</th><th>MSZoning</th><th>LotFrontage</th><th>LotArea</th><th>Street</th><th>Alley</th><th>LotShape</th><th>...</th></tr><tr><td>1</td><td>1461</td><td>20</td><td>"RH"</td><td>80</td><td>11622</td><td>"Pave"</td><td>"NA"</td><td>"Reg"</td><td></td></tr><tr><td>2</td><td>1462</td><td>20</td><td>"RL"</td><td>81</td><td>14267</td><td>"Pave"</td><td>"NA"</td><td>"IR1"</td><td></td></tr><tr><td>3</td><td>1463</td><td>60</td><td>"RL"</td><td>74</td><td>13830</td><td>"Pave"</td><td>"NA"</td><td>"IR1"</td><td></td></tr><tr><td>4</td><td>1464</td><td>60</td><td>"RL"</td><td>78</td><td>9978</td><td>"Pave"</td><td>"NA"</td><td>"IR1"</td><td></td></tr><tr><td>5</td><td>1465</td><td>120</td><td>"RL"</td><td>43</td><td>5005</td><td>"Pave"</td><td>"NA"</td><td>"IR1"</td><td></td></tr><tr><td>6</td><td>1466</td><td>60</td><td>"RL"</td><td>75</td><td>10000</td><td>"Pave"</td><td>"NA"</td><td>"IR1"</td><td></td></tr><tr><td>7</td><td>1467</td><td>20</td><td>"RL"</td><td>missing</td><td>7980</td><td>"Pave"</td><td>"NA"</td><td>"IR1"</td><td></td></tr><tr><td>8</td><td>1468</td><td>60</td><td>"RL"</td><td>63</td><td>8402</td><td>"Pave"</td><td>"NA"</td><td>"IR1"</td><td></td></tr><tr><td>9</td><td>1469</td><td>20</td><td>"RL"</td><td>85</td><td>10176</td><td>"Pave"</td><td>"NA"</td><td>"Reg"</td><td></td></tr><tr><td>10</td><td>1470</td><td>20</td><td>"RL"</td><td>70</td><td>8400</td><td>"Pave"</td><td>"NA"</td><td>"Reg"</td><td></td></tr><tr><td>...</td></tr><tr><td>1459</td><td>2919</td><td>60</td><td>"RL"</td><td>74</td><td>9627</td><td>"Pave"</td><td>"NA"</td><td>"Reg"</td><td></td></tr></tbody></table>

<pre class='language-julia'><code class='language-julia'>size(X_test_full)</code></pre>
<pre class="code-output documenter-example-output" id="var-hash152321">(1459, 80)</pre>

<pre class='language-julia'><code class='language-julia'>X_test = select(X_test_full, Cols(x -&gt; eltype(X_test_full[:, x]) &lt;: Union{Number, Missing}));</code></pre>


<pre class='language-julia'><code class='language-julia'>size(X_test)</code></pre>
<pre class="code-output documenter-example-output" id="var-hash907495">(1459, 37)</pre>

<pre class='language-julia'><code class='language-julia'>(X_train, X_valid), (y_train, y_valid) = partition((X, y), 0.8, multi=true, rng=0);</code></pre>



<div class="markdown"><h2>Preliminary Investigation</h2></div>


<pre class="code-output documenter-example-output" id="var-hash154650">(1168, 37)</pre>

<pre class='language-julia'><code class='language-julia'>describe(X_train, :nmissing)</code></pre>
<table><tbody><tr><th></th><th>variable</th><th>nmissing</th></tr><tr><td>1</td><td>:Id</td><td>0</td></tr><tr><td>2</td><td>:MSSubClass</td><td>0</td></tr><tr><td>3</td><td>:LotFrontage</td><td>212</td></tr><tr><td>4</td><td>:LotArea</td><td>0</td></tr><tr><td>5</td><td>:OverallQual</td><td>0</td></tr><tr><td>6</td><td>:OverallCond</td><td>0</td></tr><tr><td>7</td><td>:YearBuilt</td><td>0</td></tr><tr><td>8</td><td>:YearRemodAdd</td><td>0</td></tr><tr><td>9</td><td>:MasVnrArea</td><td>6</td></tr><tr><td>10</td><td>:BsmtFinSF1</td><td>0</td></tr><tr><td>...</td></tr><tr><td>37</td><td>:YrSold</td><td>0</td></tr></tbody></table>

<pre class='language-julia'><code class='language-julia'># Function for comparing different approaches
function score_dataset(X_train, X_valid, y_train, y_valid)
    Forest = @load RandomForestRegressor pkg=DecisionTree verbosity=0
    model = Forest(n_trees=100, rng=0)
    mach = machine(model, X_train, y_train, scitype_check_level=0)
    fit!(mach, verbosity=0)
    preds = predict(mach, X_valid)
    return mean_absolute_error(preds, y_valid)
end</code></pre>
<pre class="code-output documenter-example-output" id="var-score_dataset">score_dataset (generic function with 1 method)</pre>

<pre class='language-julia'><code class='language-julia'>cols_with_missing = names(X_train, any.(ismissing, eachcol(X_train))) # pick columns that contain missing values</code></pre>
<pre class="code-output documenter-example-output" id="var-cols_with_missing">3-element Vector{String}:
 "LotFrontage"
 "MasVnrArea"
 "GarageYrBlt"</pre>

<pre class='language-julia'><code class='language-julia'>reduced_X_train = select(X_train, Not(cols_with_missing));</code></pre>


<pre class='language-julia'><code class='language-julia'>reduced_X_valid = select(X_valid, Not(cols_with_missing));</code></pre>


<pre class='language-julia'><code class='language-julia'>begin
    println("MAE (Drop columns with missing values):")
    println(score_dataset(reduced_X_train, reduced_X_valid, y_train, y_valid))
end</code></pre>


<pre class='language-julia'><code class='language-julia'>my_imputer = FillImputer()</code></pre>
<pre class="code-output documenter-example-output" id="var-my_imputer">FillImputer(
  features = Symbol[], 
  continuous_fill = MLJModels._median, 
  count_fill = MLJModels._round_median, 
  finite_fill = MLJModels._mode)</pre>

<pre class='language-julia'><code class='language-julia'>mach = machine(my_imputer, X_train) |&gt; fit!</code></pre>
<pre class="code-output documenter-example-output" id="var-mach">trained Machine; caches model-specific representations of data
  model: FillImputer(features = Symbol[], …)
  args: 
    1:	Source @464 ⏎ ScientificTypesBase.Table{Union{AbstractVector{Union{Missing, ScientificTypesBase.Count}}, AbstractVector{ScientificTypesBase.Count}}}
</pre>

<pre class='language-julia'><code class='language-julia'>imputed_X_train = MLJ.transform(mach, X_train);</code></pre>


<pre class='language-julia'><code class='language-julia'>imputed_X_valid = MLJ.transform(mach, X_valid);</code></pre>


<pre class='language-julia'><code class='language-julia'>begin
    println("MAE (Imputation):")
    println(score_dataset(imputed_X_train, imputed_X_valid, y_train, y_valid))
end</code></pre>



<div class="markdown"><h2>Part A</h2></div>

<pre class='language-julia'><code class='language-julia'>begin
    final_imputer = FillImputer()
    impute_mach = machine(final_imputer, X_train) |&gt; fit!
    final_X_train = MLJ.transform(impute_mach, X_train)
    final_X_valid = MLJ.transform(impute_mach, X_valid)
end;</code></pre>


<pre class='language-julia'><code class='language-julia'>begin
    Forest = @load RandomForestRegressor pkg=DecisionTree verbosity=0
    forest = Forest(n_trees=100, rng=0)
    final_mach = machine(forest, final_X_train, y_train, scitype_check_level=0) |&gt; fit!
    # Get validation predictions and MAE
    preds_valid = predict(final_mach, final_X_valid)
    println("MAE (Your approach):")
    println(mean_absolute_error(preds_valid, y_valid))
end</code></pre>



<div class="markdown"><h2>Part B</h2></div>

<pre class='language-julia'><code class='language-julia'>final_X_test = MLJ.transform(impute_mach, X_test)</code></pre>
<table><tbody><tr><th></th><th>Id</th><th>MSSubClass</th><th>LotFrontage</th><th>LotArea</th><th>OverallQual</th><th>OverallCond</th><th>YearBuilt</th><th>YearRemodAdd</th><th>...</th></tr><tr><td>1</td><td>1461</td><td>20</td><td>80</td><td>11622</td><td>5</td><td>6</td><td>1961</td><td>1961</td><td></td></tr><tr><td>2</td><td>1462</td><td>20</td><td>81</td><td>14267</td><td>6</td><td>6</td><td>1958</td><td>1958</td><td></td></tr><tr><td>3</td><td>1463</td><td>60</td><td>74</td><td>13830</td><td>5</td><td>5</td><td>1997</td><td>1998</td><td></td></tr><tr><td>4</td><td>1464</td><td>60</td><td>78</td><td>9978</td><td>6</td><td>6</td><td>1998</td><td>1998</td><td></td></tr><tr><td>5</td><td>1465</td><td>120</td><td>43</td><td>5005</td><td>8</td><td>5</td><td>1992</td><td>1992</td><td></td></tr><tr><td>6</td><td>1466</td><td>60</td><td>75</td><td>10000</td><td>6</td><td>5</td><td>1993</td><td>1994</td><td></td></tr><tr><td>7</td><td>1467</td><td>20</td><td>70</td><td>7980</td><td>6</td><td>7</td><td>1992</td><td>2007</td><td></td></tr><tr><td>8</td><td>1468</td><td>60</td><td>63</td><td>8402</td><td>6</td><td>5</td><td>1998</td><td>1998</td><td></td></tr><tr><td>9</td><td>1469</td><td>20</td><td>85</td><td>10176</td><td>7</td><td>5</td><td>1990</td><td>1990</td><td></td></tr><tr><td>10</td><td>1470</td><td>20</td><td>70</td><td>8400</td><td>4</td><td>5</td><td>1970</td><td>1970</td><td></td></tr><tr><td>...</td></tr><tr><td>1459</td><td>2919</td><td>60</td><td>74</td><td>9627</td><td>7</td><td>5</td><td>1993</td><td>1994</td><td></td></tr></tbody></table>

<pre class='language-julia'><code class='language-julia'># Fill in the line below: get test predictions
preds_test = predict(final_mach, final_X_test)</code></pre>
<pre class="code-output documenter-example-output" id="var-preds_test">1459-element Vector{Float64}:
 129529.76
 150821.75
 181431.32
 183204.75
 186289.32
 189813.35
 175749.72
      ⋮
  82270.52
  81732.5
  87298.61
 167994.5
 119096.07
 242675.13</pre>

<pre class='language-julia'><code class='language-julia'>begin
    output = DataFrame("Id" =&gt; X_test.Id,
                           "SalePrice" =&gt; preds_test)
    CSV.write("data//home-data-for-ml-course//submissions_02x02.csv", output)
end</code></pre>
<pre class="code-output documenter-example-output" id="var-output">"data//home-data-for-ml-course//submissions_02x02.csv"</pre>
<div class='manifest-versions'>
<p>Built with Julia 1.9.1 and</p>
CSV 0.10.11<br>
DataFrames 1.5.0<br>
MLJ 0.19.2<br>
MLJDecisionTreeInterface 0.4.0
</div>

<!-- PlutoStaticHTML.End -->
~~~