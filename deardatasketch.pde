Table table;
int[][] heatmap = new int[12][5]; 

void setup() {
  size(800, 600);
  
  table = loadTable("lastfm.csv", "header"); 
  
  if (table == null) {
    println("ERROR: could not find lastfm.csv.");
    return;
  }
  
  println("Data loaded successfully! Processing rows...");

  for (TableRow row : table.rows()) {
    
    // time is in column 4
    String timeString = row.getString(4); 
    
    //  energy level is column 5
    int energy = row.getInt(5); 
    
    // use my method to simplify the time into a format that fits in a heatmap
    int hourBin = getHour(timeString);
    
    // printing to see that data is loaded correctly
    println("Time: " + timeString + " -> Bin: " + hourBin + " | Energy: " + energy);
    
    // adding the data into a heatmap
    if (hourBin >= 0 && hourBin < 12 && energy >= 1 && energy <= 5) {
      heatmap[hourBin][energy - 1]++;
    }
  }
}

void draw() {
  background(240);
  
  int cellW = 50;
  int cellH = 60;
  int xOffset = 100;
  int yOffset = 100;
  
  // finding the highest count,so I can figure out how dark the darkest square should be
  int maxCount = 1;
  for (int c = 0; c < 12; c++) {
    for (int r = 0; r < 5; r++) {
      if (heatmap[c][r] > maxCount) {
        maxCount = heatmap[c][r];
      }
    }
  }

  // drawing the grid
  for (int c = 0; c < 12; c++) {
    for (int r = 0; r < 5; r++) {
      
      // map() turns the play count into a shade between 0 and 255 by scaling it up
      float intensity = map(heatmap[c][r], 0, maxCount, 0, 255);
      
      // 255 - intensity means high counts become dark, low counts stay light
      fill(255 - intensity, 255 - intensity, 255); 
      stroke(200);
      
      int yPos = yOffset + ((4 - r) * cellH); 
      rect(xOffset + (c * cellW), yPos, cellW, cellH);
      
      // drawing the numbers inside each of the boxes
      fill(0);
      textAlign(CENTER, CENTER);
      if (heatmap[c][r] > 0) {
        text(heatmap[c][r], xOffset + (c * cellW) + cellW/2, yPos + cellH/2);
      }
    }
  }
  
  // drawing the labels
  fill(0);
  textAlign(CENTER, TOP);
  for (int c = 0; c < 12; c++) {
    text((c * 2) + ":00", xOffset + (c * cellW) + cellW/2, yOffset + (5 * cellH) + 10);
  }
  
  textAlign(RIGHT, CENTER);
  for (int r = 0; r < 5; r++) {
    text("Energy " + (r + 1), xOffset - 10, yOffset + ((4 - r) * cellH) + cellH/2);
  }
  
  // Title
  textAlign(LEFT, TOP);
  textSize(16);
  text("Music Listening Rhythm", xOffset, 40);
  
  noLoop(); 
}

// this method takes the time, makes it an integer that I can easily add to the table
int getHour(String timeString) {
  if (timeString == null || timeString.length() == 0) return 0;
  
  // split "hour:minute" by the colon
  String[] parts = split(timeString, ':');
  
  // take the first part ("hour") and turn it into an int
  int hour = int(parts[0]); 
  
  return hour / 2; //divide by 2 to put it into the table
}
