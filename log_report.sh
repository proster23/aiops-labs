#!/bin/bash
LOG=${1:-access.log}
OUT="report-$(date +%F).txt"
{
  echo "=== 日志分析报告 $(date '+%F %T') ==="
  echo "总请求数: $(wc -l < "$LOG")"
  echo "--- 5xx 最多的 IP Top10 ---"
  grep -E ' 5[0-9]{2} ' "$LOG" | awk '{print $1}' | sort | uniq -c | sort -nr | head
  echo "--- 访问量 Top10 URL ---"
  awk '{c[$7]++} END{for(u in c) print c[u], u}' "$LOG" | sort -nr | head
  echo "--- 各小时请求量 ---"
  awk '{split($4,t,":"); c[t[2]]++} END{for(h in c) print h"点", c[h]}' "$LOG" | sort
} > "$OUT"
echo "报告已生成: $OUT"
