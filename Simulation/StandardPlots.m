% This is the standard/default plotting function you can use in your TestCase. 
% It plots all simulation results to give you a quick overview of your data. 
% It can also be used as a baseline or template for creating custom plotting functions.
function StandardPlots(Results)
  % Hack that helps with graph scaling
  figure(1, 'position', [0, 0, 1920, 1000]);

  set(groot, 'DefaultLineLineWidth', 5);

  plot(Results.Time, Results.X);
  hold on;
  plot(Results.Time, Results.Vx);
  plot(Results.Time, Results.Y);
  plot(Results.Time, Results.Vy);
  plot(Results.Time, Results.AoA);
  hold off;

  xlabel('Time (s)');

  l = legend('Postion X (m)', 'Velocity X (m)', 'Position Y (m)', 'Velocity Y (m/s)', 'AoA (deg)');
  set(l, 'FontSize', 25);
  set(gca, 'FontSize', 25);

  grid on;
endfunction