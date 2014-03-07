# -*- coding: utf-8 -*-
require File.expand_path('../../command_str_params', __FILE__)

module SvgGeometry
  class Path < CommandStrParams
    class Arc
      attr_accessor :start, :endp, :radius, :rotation, :arc, :sweep, 
                    :center, :theta, :delta, :start_angle, :end_angle,
                    :mNumSegs, :mDelta, :mT
      
      def initialize(start, radius, rotation, arc, sweep, endp)
        self.start = start
        self.radius = radius
        self.rotation = rotation.to_f
        self.arc = (arc == 0) ? false : true
        self.sweep = (sweep == 0) ? false : true
        self.endp = endp

        self.parametrize if !(self.radius.x == 0 && self.radius.y == 0)
      end

      def ==(other)
        [:start, :endp, :radius, :rotation, :arc, :sweep].map { |attr| self.send(attr) == other.send(attr) }.inject(true) { |sum, cond| sum && cond }
      end

      # Algorítmo extraído de 
      # http://www.w3.org/TR/SVG/implnote.html#ArcImplementationNotes
      def parametrize
        # F.6.6.1
        rx = self.radius.x = self.radius.x.abs 
        ry = self.radius.y = self.radius.y.abs 

        # F.6.5.1:
        angle = Util.degrees_to_rad(self.rotation);
        mSinPhi = sin(angle);
        mCosPhi = cos(angle);

        #puts "start => #{self.start.x},#{self.start.x}, end => #{self.endp.x}, #{self.endp.y}"
        #puts "arc_flag => #{arc}, sweep_flag => #{sweep}"
        #puts ("rx => #{rx}, ry => #{ry}, angle => #{angle}")

        x1p =  mCosPhi * ((self.start.x - self.endp.x) / 2.0) + mSinPhi * ((self.start.y - self.endp.y) / 2.0)
        y1p = -mSinPhi * ((self.start.x - self.endp.x) / 2.0) + mCosPhi * ((self.start.y - self.endp.y) / 2.0);

        # self is the root in F.6.5.2 and the numerator under that root:
        root = 0.0
        numerator = rx*rx*ry*ry - rx*rx*y1p*y1p - ry*ry*x1p*x1p;

        if (numerator >= 0.0)
          root = sqrt(numerator/(rx*rx*y1p*y1p + ry*ry*x1p*x1p));
          if (self.arc == self.sweep)
            root = -root;
          end
        else
          # F.6.6 step 3 - |numerator < 0.0|. self is equivalent to the result
          # of F.6.6.2 (lamedh) being greater than one. What we have here is
          # ellipse radii that are too small for the ellipse to reach between
          # self.start and self.endp. We scale the radii up uniformly so that the
          # ellipse is just big enough to fit (i.e. to the point where there is
          # exactly one solution).

          s = sqrt(1.0 - numerator/(rx*rx*ry*ry)); # equiv to eqn F.6.6.2
          self.radius.x *= s
          self.radius.y *= s
          rx = self.radius.x  # F.6.6.3
          ry = self.radius.y
          root = 0.0;
          #puts "s => #{s}, rx => #{rx}, ry => #{ry}"
        end

        #puts "x1p => #{x1p}, y1p => #{y1p}, numerator => #{numerator}, root => #{root}"

        cxp =  root * rx * y1p / ry;  # F.6.5.2
        cyp = -root * ry * x1p / rx;

        self.center = Position.new((mCosPhi * cxp - mSinPhi * cyp) + ((self.start.x + self.endp.x) / 2.0),
                                   (mSinPhi * cxp + mCosPhi * cyp) + ((self.start.y + self.endp.y) / 2.0))

        #puts ("center => #{self.center.x},#{self.center.y}")

        #mTheta = CalcVectorAngle(1.0, 0.0, (x1dash-cxdash)/mRx, (y1dash-cydash)/mRy);
        self.theta = Util.calc_vector_angle(1.0, 0.0, (x1p-cxp)/rx, (y1p-cyp)/ry)
        #double dtheta = CalcVectorAngle((x1dash-cxdash)/mRx, (y1dash-cydash)/mRy,
        #                          (-x1dash-cxdash)/mRx, (-y1dash-cydash)/mRy);
        self.delta = Util.calc_vector_angle((x1p-cxp)/rx, (y1p-cyp)/ry, (-x1p-cxp)/rx, (-y1p-cyp)/ry)
        #self.theta = Util.angle_of_vector(Position.new((x1p-cxp)/rx, (y1p-cyp)/ry));    # F.6.5.5
        #self.delta = Util.angle_of_vector(Position.new((-x1p-cxp)/rx, (-y1p-cyp)/ry)) - self.theta; # F.6.5.6
        
        if !self.sweep && self.delta > 0
          self.delta -= 2.0 * PI;
        elsif self.sweep && self.delta < 0
          self.delta += 2.0 * PI;
        end
        #puts ("theta => #{self.theta}, delta => #{self.delta}")
    
        # Convert into cubic bezier segments <= 90deg
        self.mNumSegs = (self.delta/(PI/2.0)).abs.ceil.to_i
        self.mDelta = self.delta/self.mNumSegs.to_f
        self.mT = 8.0/3.0 * sin(self.mDelta/4.0) * sin(self.mDelta/4.0) / sin(self.mDelta/2.0)
        #puts "mNumSegs => #{mNumSegs}, mDelta => #{mDelta}, mT => #{mT}"
      end

      def point_by_percent(perct)
        return Position.new(0,0) if (self.radius.x == 0 && self.radius.y == 0)
        angle = self.theta + (self.delta * perct)
        cos_angle = cos(angle)
        sin_angle = sin(angle)
        
        mCosPhi = cos(Util.degrees_to_rad(self.rotation))
        mSinPhi = sin(Util.degrees_to_rad(self.rotation))
    
        x = mCosPhi * cos_angle * self.radius.x - mSinPhi * sin_angle * self.radius.y + self.center.x
        y = mSinPhi * cos_angle * self.radius.x + mCosPhi * sin_angle * self.radius.y + self.center.y
        
        Position.new(x, y)
      end

      def length
        @lenght ||= (self.radius.x == 0 && self.radius.y == 0) ? 0 : calc_length
      end

      def calc_length(pretty = false)
        segments = []
        mFrom = self.start.clone
        to = Position.new(0, 0)
        cp1 = Position.new(0, 0)
        cp2 = Position.new(0, 0)

        mCosPhi = cos(Util.degrees_to_rad(self.rotation))
        mSinPhi = sin(Util.degrees_to_rad(self.rotation))
        mRx = self.radius.x
        mRy = self.radius.y
        mC = self.center

        theta_temp = self.theta

        (self.mNumSegs).times do
          cosTheta1 = cos(theta_temp);
          sinTheta1 = sin(theta_temp);
          theta2 = theta_temp + mDelta;
          cosTheta2 = cos(theta2);
          sinTheta2 = sin(theta2);

          # a) calculate endpoint of the segment:
          to.x = mCosPhi * mRx*cosTheta2 - mSinPhi * mRy*sinTheta2 + mC.x;
          to.y = mSinPhi * mRx*cosTheta2 + mCosPhi * mRy*sinTheta2 + mC.y;

          # b) calculate gradients at start/end points of segment:
          cp1.x = mFrom.x + mT * ( - mCosPhi * mRx*sinTheta1 - mSinPhi * mRy*cosTheta1);
          cp1.y = mFrom.y + mT * ( - mSinPhi * mRx*sinTheta1 + mCosPhi * mRy*cosTheta1);

          cp2.x = to.x + mT * ( mCosPhi * mRx*sinTheta2 + mSinPhi * mRy*cosTheta2);
          cp2.y = to.y + mT * ( mSinPhi * mRx*sinTheta2 - mCosPhi * mRy*cosTheta2);

          segments << CubicBezier.new(mFrom.clone, cp1.clone, cp2.clone, to.clone)
          #puts "<path d='M#{mFrom.x.round(2)},#{mFrom.y.round(2)} C#{cp1.x.round(2)},#{cp1.y.round(2)} #{cp2.x.round(2)},#{cp2.y.round(2)} #{to.x.round(2)},#{to.y.round(2)}' stroke='red' />"

          # do next segment
          theta_temp = theta2;
          mFrom = to.clone;
        end

        #puts "<path d='M#{mFrom.x.round(2)},#{mFrom.y.round(2)} L#{self.start.x.round(2)},#{self.start.y.round(2)}' stroke='red' />"
        
        segments.inject(0) do |length_sum, segment|
          puts ">> #{segment.pretty_length}" if pretty
          length_sum + segment.length
        end
      end

      def to_s
        "Arc: start: #{start} | endp: #{endp}"
      end

      def pretty_length
        "#{to_s} | length: #{length(true)}"
      end
    end
  end
end
