library(shiny)

# padding/margin values are : top, right, bottom, left

shinyUI(fluidPage(
    tags$style(type="text/css",
      "body  {background-color: #BBBBBB !important; }",
      "input {color: #990000 !important; max-width: 100px !important; display: inline-block !important;}",
      "h2 {color: #1C6C17 !important; padding: 2px 0px 2px 8px !important; margin: 0px !important; }",
      "h3 {color: #AF0810 !important; padding: 0px 0px 0px 4px !important; margin: 4px 0px 0px 4px !important; border: 0px solid black; }",
      "h4 {color: #0000AA !important; padding: 4px 0px 6px 0px !important; margin: 0px !important; }",
      "h5 {color: #222222 !important; padding: 0px 0px 0px 8px !important; margin: 0px !important; }",
      "div.well      {padding:  4px  4px  4px  4px !important; margin: 0px 0px 2px 0px !important; background-color: #FFFFFF; border: 0px dashed red; }", 
      "div.span3     {padding:  2px 10px  2px 10px !important; margin: 4px 8px 4px 0px !important; background-color: #FFFFFF; border: 0px solid black !important; border-left: 0px solid #AAAAAA !important; border-right: 1px solid #AAAAAA !important; }", 
      "div.span4     {padding:  2px 10px  2px 10px !important; margin: 4px 4px 4px 0px !important; background-color: #FBFBFB; }", 
      "div.span12    {padding:  2px  2px  2px  2px !important; margin: 1px 0px 4px 0px !important;                            border: 0px dotted blue; }", 
      "div.row-fluid {padding:  0px  0px  0px  0px !important; margin: 0px 0px 0px 0px !important; background-color: #FFFFFF; border: 0px dashed orange; }", 
      "div.tabbable  {padding:  0px  0px  0px  0px !important;                                     background-color: #EEEEEE; border: 0px dashed magenta !important; }", 
      "div.tab-content {                                                                           background-color: #EEEEEE; border: 0px dashed magenta !important; }", 
      "ul.nav.nav-tabs {margin-bottom: 1px !important; background-color: #EEEEEE !important; }",
      ".nav-tabs > li > a:hover {color: #AF0810 !important; font-weight: bold !important; background-color: #FF0000 !important; }"
    ),
    # "div.span3     {padding:  2px 10px  2px 10px !important; margin: 4px 4px 4px 0px !important; background-color: #EFFFEF; border: 0px solid #009900; }", 

  title = "Advanced Buy .vs Rent Calculator",

  div("", style = "padding: 10px 0px 0px 0px !important; width: 100%; "),

  wellPanel(
  fluidRow(
    h2("Advanced Buy vs. Rent Calculator")
  )), 

  div("", style = "padding: 6px 0px 0px 0px !important; width: 100%; "),

  fluidRow(
    tabsetPanel(type = "tabs",
    
      tabPanel("Description", 
        wellPanel(
        fluidRow(
          column(12,
            p(style = "padding: 0px 12px 0px 6px;", 
	       "A calculator for a more comprehensive and realistic scenario comparing the cost/benefits of 
	       buying a property vs. renting a comparable one."),
            p(style = "padding: 0px 12px 0px 6px;", 
	       "It takes into account taxes, and tax benefits of the mortgage interest deduction (if applicable when compared
	       with a standard deduction), the benefits of re-investing money potentially saved by renting instead of buying,
	       as well of the benefit of the return of investment of the capital not put into a down-payment."),
            div("", style = "padding: 6px 0px 0px 0px !important; width: 100%; "),

            p(style = "padding: 0px 12px 0px 6px;", 
	        "Given the parameter values, 250 simulations are performed, with stochastic 'predictions' of 
		 the property appreciation, (alternative) investment return, inflation, rent increase."
	    ),
            p(style = "padding: 0px 12px 0px 6px;", 
	        "For each simulation a 'trade-off' value is computed, giving the difference between buying the given
		 property and renting (including the return of the investment of the cash not put into the property).
		 Positive values are in favor of buying, negative indicate that renting would be more beneficial financially."
	    ),
            p(style = "padding: 0px 12px 0px 6px;", 
		 "Results are summarized in three plots, showing 
		  (1) the trends of the 'tradeoff' amount, 
		  (2) the fraction of simulations favoring buying over renting, over time,
		  (3) the distribution of tradeoff amounts over time, highligthing the distributions at 1/2, 3/4 and at the end of the loan period."
	    ),
            div("", style = "padding: 6px 0px 0px 0px !important; width: 100%; "),

	    h3("Terse explanation of the input parameters:")
	)), 

        fluidRow(
          column(5, offset = 1,
     	    h4("House and Mortgage"),
              strong("Purchase Price ($) :"),
              strong("Down Payment (%) :"), br(), 
              strong("Mortgage Rate (%) :"), br(), 
              strong("Duration (years) :"), br(), 
	      strong("Initial Fixed Costs ($) :"), span("additional cost incurred when buying a property, e.g. closing costs, or repairs"), br(), 
            div("", style = "padding: 6px 0px 0px 0px !important; width: 100%; "),
       
    	    h4("Ownership Costs: Prop. Taxes, Insurance, Fees"),
              strong("Prop. Tax Rate (%) :"), br(),
              strong("Insurance Cost ($) :"), span("home-owner insurance premium (annual)."), br(),
              strong("HOA Monthly Fee ($) :"), span("home-owner association fees (monthly)."), br(),
            div("", style = "padding: 6px 0px 0px 0px !important; width: 100%; "),
          
    	    h4("Rent"),
              strong("Rent, Monthly ($) :"), span("ideally the monthly for a comparable property."), br(), 
	      strong("Renter Insurance ($) :"), br(),
	      strong("Fraction of Saved Cash Re-invested (%) :"), span("if the total costs of renting are lower than those of owning, 
	                                                                a portion of the saved cash can be re-invested.  
									This parameter regulated the fraction of saved cash that is added to the investments."), br(),
            div("", style = "padding: 6px 0px 0px 0px !important; width: 100%; "),
    
    	    h4("Income Tax Related"),
              strong("Marginal Income Tax (%)"), span("tax rate to use to calculate the potential tax-savings of the deduction of mortgage interests."), br(),
              strong("Other Itemized Deductions ($): "), span("the mortgage interest deduction can only be taken if one itemizes all deductions, thus
	                                                       losing the standard deduction (see next).  
							       Because of this, the actual benefit of the mortgage interest
							       deduction is only related to the portion that exceeds the standard deduction."), br(), 
              strong("Standard Deduction :"),  span("please note that it may be different if filing as married or separately."),
            div("", style = "padding: 6px 0px 0px 0px !important; width: 100%; ")
	  ),

          column(6,
            h4("Property Appreciation"),
	      span("(Assuming uncorrelated normally distributed values)"), br(),
              strong("Appreciation (%) :"), span("mean yearly increase of property values."), br(),
              strong("Appreciation Std.Dev. (%) :"), span("'volatility of the property value changes."),
            div("", style = "padding: 6px 0px 0px 0px !important; width: 100%; "),
          
            h4("Cash Investment Return"),
	      span("(Assuming uncorrelated normally distributed values)"), br(),
              strong("Return (%) :"),  span("mean yearly return of 'cash' investments."), br(),
              strong("Return Std.Dev. (%) :"), span("'volatility of 'cash' investment returns."),
            div("", style = "padding: 6px 0px 0px 0px !important; width: 100%; "),

            h4("Inflation"),
	      span("(Assuming uncorrelated normally distributed values)"), br(),
              strong("Inflation (%) :"), span("mean yearly inflation rate."), br(), 
              strong("Inflation Std.Dev. (%) :"), span("'volatility of inflation."),
            div("", style = "padding: 6px 0px 0px 0px !important; width: 100%; "), 
          
            h4("Rent Increase"),
              strong("Extra Increase Over Inflation (%) :"), span("Extra rate of increase of rent, on top of inflation."), br(), 
	      span("Values are drawn from an exponential distribution with this mean.")
	  )
        )
	)
      ),
    
      tabPanel("Inputs: Main", 
        wellPanel(
        fluidRow(
          column(3,
     	    h4("House and Mortgage"),
            numericInput("start_prop_value",                 "Purchase Price ($)", min = 30000, max = 2e6, value = 200000, step = 1e4),
            numericInput("down_payment_pct",                 "Down Payment (%)", min = 5, max = 100, value = 20.0, step = 5.0),
            numericInput("mortgage_rate",                    "Mortgage Rate (%)", min = 2.5, max = 10.0, value = 4.5, step = 0.125),
            numericInput("n_years",                          "Duration (years)", min = 5, max = 30, value = 30, step = 5),
            numericInput("initial_fixed_costs",              "Initial Fixed Costs ($)", min = 0.0, max = 1e5, value = 5000, step = 500.0)
          ),
       
          column(3,
    	    h4("Prop. Taxes, Insurance, Fees"),
            numericInput("prop_tax_rate_pct",                "Prop. Tax Rate (%)", min = 0.0, max = 5.0, value = 2.0, step = 0.125),
            numericInput("prop_insurance",                   "Insurance Cost ($)", min = 500, max = 20000, value = 2000.0, step = 500),
            numericInput("HOA_monthly_fee",                  "HOA Monthly Fee ($)", min = 0, max = 10000, value = 500.0, step = 100)
          ),
          
          column(3,
    	    h4("Rent"),
            numericInput("start_rent",                       "Rent, Monthly ($)", min = 500, max = 30000, value = 1500.0, step = 100),
            numericInput("rent_insurance",                   "Renter Insurance ($)", min = 0, max = 2000, value = 250.0, step = 50), 
            numericInput("fraction_extra_cash_invested_pct", "Fraction of Saved Cash Re-invested (%)", min = 0.0, max = 100.0, value = 50.0, step = 5.0)
          ), 
    
          column(3,
    	    h4("Income Tax Related", title="Explanation"),
            numericInput("income_tax_rate_pct",              "Marginal Income Tax (%)", min = 10.0, max = 75.0, value = 25.0, step = 1.0),
            numericInput("itemized_deductions",              "Other Itemized Deductions ($)", min = 0, max = 100000, value = 0.0, step = 1000),
            numericInput("std_deduction",                    "Standard Deduction", min = 0.0, max = 20000, value = 12200, step = 100),
    	    tags$input(id = "n_sim", type = "number", value = 250, style = "visibility: hidden;")
          )
        ))
      ),
    
      tabPanel("Inputs: Annual Variations", 
        wellPanel(
        fluidRow(
          column(3,
            h4("Property Appreciation"),
            numericInput("annual_appreciation",              "Appreciation (%)", min = 0.0, max = 25.0, value = 3.0, step = 0.5),
            numericInput("annual_appreciation_sd",           "Appreciation Std.Dev. (%)", min = 0.0, max = 10.0, value = 2.0, step = 0.5)
          ),
          column(3,
            h4("Cash Investment Return"),
            numericInput("annual_inv",                       "Return (%)", min = 0.0, max = 20.0, value = 5.0 , step = 0.5),
            numericInput("annual_inv_sd",                    "Return Std.Dev. (%)", min = 0.0, max = 10.0, value = 7.0, step = 0.5)
          ),
          column(3,
            h4("Inflation"),
            numericInput("annual_inflation",                 "Inflation (%)", min = 0.0, max = 15.0, value = 1.5, step = 0.5),
            numericInput("annual_inflation_sd",              "Inflation Std.Dev. (%)", min = 0.0, max = 5.0, value = 1.0, step = 0.5)
          ),
          column(3,
            h4("Rent Increase"),
            numericInput("annual_rent_extra_increase_mean",  "Extra Increase Over Inflation (%)", min = 0.0, max = 10.0, value = 0.5, step = 0.25)
          )
        ))
      )
    
    )
    # end of tabsetPanel
  
  ),
  # end of fluidRow containing tabs

  wellPanel(
  fluidRow(
    column(8, offset = 2, 
      plotOutput("multiPlot", height = "600px")
    )
  ))

))

