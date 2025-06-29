import 'package:finshyt/constants/app_colors.dart';
import 'package:finshyt/constants/app_dimensions.dart';
import 'package:finshyt/models/chart_data_models.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Chart extends StatelessWidget {
  const Chart({
    super.key,
    required this.data,
    required this.chartType,
    required this.maxY,
    required this.title1,
    this.title2,
    required this.primaryColor,
    this.secondaryColor,
  });

  final List<ChartData> data;
  final ChartType chartType;
  final double maxY;
  final String title1;
  final String? title2;
  final Color primaryColor;
  final Color? secondaryColor;

  @override
  Widget build(BuildContext context) {
    // clculating dynamic width based on data length
    double barWidth = chartType == ChartType.doubleBar ? 16 : 20;
    double spacing = 24;
    double minChartWidth =
        MediaQuery.of(context).size.width - 48; // forcontainer padding
    double calculatedWidth =
        (data.length *
            (barWidth * (chartType == ChartType.doubleBar ? 2 : 1) + spacing)) +
        40;
    double chartWidth = calculatedWidth > minChartWidth
        ? calculatedWidth
        : minChartWidth;

    return Container(
      height: 240,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Insights',
              style: GoogleFonts.inter(
                color: AppColors.primary,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Column(
            children: [
              title2 == null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.circle_outlined,
                          color: AppColors.secondary,
                          size: 12,
                        ),
                        SizedBox(width: 4),
                        Text(
                          title1,
                          style: GoogleFonts.inter(
                            color: AppColors.text,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.circle_outlined,
                          color: AppColors.warnings,
                          size: 12,
                        ),
                        SizedBox(width: 4),
                        Text(
                          title1,
                          style: GoogleFonts.inter(
                            color: AppColors.text,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.circle_outlined,
                          color: AppColors.secondary,
                          size: 12,
                        ),
                        SizedBox(width: 4),
                        Text(
                          title2!,
                          style: GoogleFonts.inter(
                            color: AppColors.text,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
              const SizedBox(height: 8),
              Container(
                height: 160,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: chartWidth,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.start,
                        maxY: maxY,
                        barTouchData: _buildTouchData(),
                        titlesData: _buildTitlesData(),
                        borderData: FlBorderData(show: false),
                        gridData: FlGridData(show: false),
                        barGroups: _buildBarGroups(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  BarChartGroupData _buildDoubleBar(int index, ChartData item) {
    return BarChartGroupData(
      x: index,
      barRods: [
        BarChartRodData(
          toY: item.primaryValue,
          color: primaryColor,
          width: 8,
          borderRadius: BorderRadius.circular(4),
        ),
        BarChartRodData(
          toY: item.secondaryValue ?? 0,
          color: secondaryColor ?? primaryColor,
          width: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  BarChartGroupData _buildSingleBar(int index, ChartData item) {
    return BarChartGroupData(
      x: index,
      barRods: [
        BarChartRodData(
          toY: item.primaryValue,
          color: primaryColor,
          width: 12,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return data.asMap().entries.map((entry) {
      int index = entry.key;
      ChartData item = entry.value;

      if (chartType == ChartType.doubleBar) {
        return _buildDoubleBar(index, item);
      } else {
        return _buildSingleBar(index, item);
      }
    }).toList();
  }

  BarTouchData _buildTouchData() {
    return BarTouchData(
      touchTooltipData: BarTouchTooltipData(
        fitInsideVertically: true,
        fitInsideHorizontally: true,
        tooltipBorderRadius: BorderRadius.circular(8),
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          if (chartType == ChartType.doubleBar) {
            String label = rodIndex == 0 ? 'Spent' : 'Budget';
            return BarTooltipItem(
              '$label : ₹${rod.toY.round()}',
              GoogleFonts.inter(
                color: AppColors.background,
                fontWeight: FontWeight.bold,
              ),
            );
          } else {
            return BarTooltipItem(
              'Goal : ₹${rod.toY.round()}',
              GoogleFonts.inter(
                color: AppColors.background,
                fontWeight: FontWeight.bold,
              ),
            );
          }
        },
      ),
    );
  }

  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 20,
          getTitlesWidget: (value, meta) {
            if (value.toInt() < data.length) {
              return Text(
                data[value.toInt()].label,
                style: GoogleFonts.inter(color: AppColors.text, fontSize: 9),
              );
            }
            return Text('');
          },
        ),
      ),
      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }
}
