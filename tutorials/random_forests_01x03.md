~~~
<!-- PlutoStaticHTML.Begin -->
<!--
    # This information is used for caching.
    [PlutoStaticHTML.State]
    input_sha = "35abd092834d508be544bc68e9f360bf74a1c63eedaabf181252c0bcefbdbc31"
    julia_version = "1.9.1"
-->
<pre class='language-julia'><code class='language-julia'>using DataFrames, CSV, MLJ, MLJDecisionTreeInterface</code></pre>


<pre class='language-julia'><code class='language-julia'>begin
    iowa_file_path = "data//home-data-for-ml-course//train.csv"
    home_data = CSV.read(iowa_file_path, DataFrame);
    y = home_data.SalePrice;
    feature_names = [:LotArea, :YearBuilt, Symbol("1stFlrSF"), Symbol("2ndFlrSF"), :FullBath, :BedroomAbvGr, :TotRmsAbvGrd];
    X = home_data[:, feature_names];

    # Split into validation and training data
    (Xtrain, Xtest), (ytrain, ytest) = partition((X, y), 0.8, rng=123, multi=true);
    
    # Specify Model
    Tree = @load DecisionTreeRegressor pkg=DecisionTree verbosity=0
    iowa_model = Tree()
    mach = machine(iowa_model, Xtrain, ytrain, scitype_check_level=0)
    # Fit Model
    fit!(mach, verbosity = 0)
    val_predictions = predict(mach, Xtest)
    val_mae = mean_absolute_error(val_predictions, ytest)
    println("Validation MAE when not specifying max_leaf_nodes: $(round(Int, val_mae))")

    # Using best value for max_leaf_nodes
    iowa_model = Tree(min_samples_leaf=5, rng=1)
    mach = machine(iowa_model, Xtrain, ytrain, scitype_check_level=0)
    fit!(mach, verbosity = 0)
    val_predictions = predict(mach, Xtest)
    val_mae = mean_absolute_error(val_predictions, ytest)
    println("Validation MAE for best value of max_leaf_nodes: $(round(Int, val_mae))")
end</code></pre>


<pre class='language-julia'><code class='language-julia'>Forest = @load RandomForestRegressor pkg=DecisionTree verbosity=0</code></pre>
<pre class="code-output documenter-example-output" id="var-Forest">RandomForestRegressor</pre>

<pre class='language-julia'><code class='language-julia'>forest = Forest()</code></pre>
<pre class="code-output documenter-example-output" id="var-forest">RandomForestRegressor(
  max_depth = -1, 
  min_samples_leaf = 1, 
  min_samples_split = 2, 
  min_purity_increase = 0.0, 
  n_subfeatures = -1, 
  n_trees = 100, 
  sampling_fraction = 0.7, 
  feature_importance = :impurity, 
  rng = Random._GLOBAL_RNG())</pre>

<pre class='language-julia'><code class='language-julia'>rf_model = machine(forest, Xtrain, ytrain, scitype_check_level=0)</code></pre>
<pre class="code-output documenter-example-output" id="var-rf_model">untrained Machine; caches model-specific representations of data
  model: RandomForestRegressor(max_depth = -1, …)
  args: 
    1:	Source @654 ⏎ ScientificTypesBase.Table{AbstractVector{ScientificTypesBase.Count}}
    2:	Source @067 ⏎ AbstractVector{ScientificTypesBase.Count}
</pre>

<pre class='language-julia'><code class='language-julia'>fit!(rf_model)</code></pre>
<pre class="code-output documenter-example-output" id="var-hash152480">trained Machine; caches model-specific representations of data
  model: RandomForestRegressor(max_depth = -1, …)
  args: 
    1:	Source @654 ⏎ ScientificTypesBase.Table{AbstractVector{ScientificTypesBase.Count}}
    2:	Source @067 ⏎ AbstractVector{ScientificTypesBase.Count}
</pre>

<pre class='language-julia'><code class='language-julia'>rf_val_predictions = predict(rf_model, Xtest)</code></pre>
<pre class="code-output documenter-example-output" id="var-rf_val_predictions">292-element Vector{Float64}:
 178613.93
 134950.14
 234560.9
 155530.5
 305688.15
 310621.37
 244759.2
      ⋮
 156312.5
 135762.4
 150215.0
  99155.71
 255391.5
 154969.5</pre>

<pre class='language-julia'><code class='language-julia'>rf_val_mae = mean_absolute_error(rf_val_predictions, ytest)</code></pre>
<pre class="code-output documenter-example-output" id="var-rf_val_mae">22869.537739726016</pre>
<div class='manifest-versions'>
<p>Built with Julia 1.9.1 and</p>
CSV 0.10.9<br>
DataFrames 1.5.0<br>
MLJ 0.19.1<br>
MLJDecisionTreeInterface 0.4.0
</div>

<!-- PlutoStaticHTML.End -->
~~~