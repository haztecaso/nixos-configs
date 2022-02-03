{ pkgs, ... }:
let
  path = "~/Documents/uni";
in
pkgs.writeScriptBin "uni-schedule"
''
#!${pkgs.python3}/bin/python3
import json, os, argparse
from datetime import datetime, timedelta

uniPath = "~/Documents/uni"

def parseTime(string):
    t = datetime.strptime(string,'%H:%M')
    t = datetime.now().replace(
            hour = t.hour,
            minute = t.minute,
            second = 0,
            microsecond = 0
            )
    return t

class Course:
    def __init__(self, id, data):
        self.id = id
        self.path = os.path.expanduser("{}/Actuales/{}".format(uniPath,self.id))
        self.name = data['name']
        self.urls = data['urls']

    def __str__(self):
        result = "{} ({})\n".format(self.name, self.id)
        result += "moodle: {}\n".format(self.url('moodle'))
        result += "collab: {}".format(self.url('collab'))
        return result

    def __repr__(self):
        return self.id

    def url(self,name):
        return self.urls[name]

    def get(self,desc):
        if desc == 'id':
            return self.id
        elif desc == 'path':
            return self.path
        elif desc == 'name':
            return self.name
        elif desc == 'moodle' or desc == 'collab':
            return self.url(desc)
        else:
            return self

class Event:
    def __init__(self, day, interval, courseId):
        self.day = int(day)
        self.courseId = courseId
        self.parseInterval(interval)

    def __repr__(self):
        start = self.start.strftime("%H:%M")
        end = self.end.strftime("%H:%M")
        return "{}-{}-{}-{}".format(self.courseId, self.day, start, end)

    def __lt__(self, other):
        return (self.start < other.start)

    def parseInterval(self, interval):
        delta = timedelta(self.day - datetime.now().weekday())
        if delta.days < 0:
            delta += timedelta(7)
        self.start, self.end = interval.split('-')
        self.start = parseTime(self.start) + delta
        self.end = parseTime(self.end) + delta


class Schedule:
    def __init__(self, inputFile):
        f = open(os.path.expanduser(inputFile), 'r')
        self.dataRAW = json.loads(f.read())
        f.close()
        self.parse()

    def parse(self):
        self.course = self.dataRAW['course']
        self.semester = self.dataRAW['semester']
        self.courses = []
        for id in self.dataRAW['courses'].keys():
            course = Course(id, self.dataRAW['courses'][id])
            self.courses.append(course)
        self.events = []
        for day in self.dataRAW['schedule'].keys():
            for interval, courseId in self.dataRAW['schedule'][day].items():
                self.events.append(Event(day,interval,courseId))
        self.events.sort()

    def getCourse(self, id):
        for course in self.courses:
            if course.id == id:
                return course

    def select(self, desc):
        if desc == 'current':
            return self.current()
        elif desc == 'next':
            return self.next()
        else:
            current = self.current()
            if current:
                return current
            else:
                return self.next()

    def current(self):
        now = datetime.now()
        for event in self.events:
            if event.start < now < event.end:
                return event, self.getCourse(event.courseId)

    def next(self, n=1):
        now = datetime.now()
        for event in self.events:
            if now < event.start and n>0:
                n = n-1
                return event, self.getCourse(event.courseId)

    def __str__(self):
        return ""

def options():
  import argparse
  parser = argparse.ArgumentParser()
  parser.add_argument("-s", "--select", choices=['current','next'],
                      help="select course")
  parser.add_argument("-g", "--get",
                      choices=['id','name','path','moodle','collab'],
                      help="get course info")
  return parser.parse_args()

def main():
  args = options()
  inputFile = "{}/schedule/current.json".format(uniPath)
  schedule = Schedule(inputFile)
  selection = schedule.select(args.select)
  if selection:
      event, course = selection
      print(course.get(args.get))
  else:
      print("{} not available".format(args.select))

if __name__ == "__main__":
    main()
''
