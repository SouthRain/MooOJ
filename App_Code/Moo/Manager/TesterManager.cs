﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Threading;
using Moo.DB;
using Moo.Utility;
using Moo.Tester;
using System.Windows.Forms;
namespace Moo.Manager
{
    /// <summary>
    ///Tester 后台进程
    /// </summary>
    public static class TesterManager
    {
        static List<ITester> testers = new List<ITester>();
        public static List<ITester> Testers
        {
            get
            {
                return testers;
            }
            set
            {
                testers = value;
            }
        }

        static Thread testThread;
        static volatile bool shouldStop;

        public static void Start()
        {
            if (testThread != null)
            {
                Stop();
            }

            shouldStop = false;
            testThread = new Thread(new ThreadStart(ThreadMain));
            testThread.Start();
        }

        public static void Stop()
        {
            shouldStop = true;
            testThread.Interrupt();
            testThread.Join();
            testThread = null;
        }

        static void ThreadMain()
        {
            while (!shouldStop)
            {
                try
                {
                    Thread.Sleep(MainLoop());
                }
                catch (Exception e)
                {
                    if (!(e is ThreadInterruptedException))
                    {
                        Logger.Log(e);
                    }
                }
            }
        }

        static int MainLoop()
        {
            using (MooDB db = new MooDB())
            {
                Record record = (from r in db.Records
                                 where r.JudgeInfo == null && r.Problem.AllowTesting
                                 select r).FirstOrDefault<Record>();
                var a = (from r in db.Records
                         where r.JudgeInfo == null
                         select r);
                if (record == null)
                {
                    return 5 * 1000;
                }
                else
                {
                    record.JudgeInfo = new JudgeInfo()
                    {
                        Record = record,
                        Score = -1,
                        Info = "正在评测"
                    };
                    db.SaveChanges();

                    Test(db, record);
                    db.SaveChanges();

                    return 0;
                }
            }
        }

        static void Test(MooDB db, Record record)
        {
            TestResult result;
            switch (record.Problem.Type)
            {
                case "Tranditional":
                    result = TestTranditional(db, record);
                    break;
                case "SpecialJudged":
                    result = TestSpecialJudged(db, record);
                    break;
                default:
                    result = new TestResult()
                    {
                        Score = 0,
                        Info = "未知的题目类型"
                    };
                    break;
            }

            Record maxScore = (from r in db.Records
                               where r.JudgeInfo != null && r.User.ID == record.User.ID && r.Problem.ID == record.Problem.ID && r.JudgeInfo.Score >= 0
                               orderby r.JudgeInfo.Score descending
                               select r).FirstOrDefault<Record>();
            if (maxScore == null)
            {
                record.User.Score += result.Score;
            }
            else if (result.Score > maxScore.JudgeInfo.Score)
            {
                record.User.Score += result.Score - maxScore.JudgeInfo.Score;
            }

            record.JudgeInfo.Score = result.Score;
            record.JudgeInfo.Info = result.Info;
        }

        static TestResult TestTranditional(MooDB db, Record record)
        {
            ITester tester = Testers[0];
            IEnumerable<TranditionalTestCase> cases = from t in db.TestCases.OfType<TranditionalTestCase>()
                                                      where t.Problem.ID == record.Problem.ID
                                                      select t;
            return tester.TestTranditional(record.Code,record.Language, cases);
        }

        static TestResult TestSpecialJudged(MooDB db, Record record)
        {
            ITester tester = Testers[0];
            IEnumerable<SpecialJudgedTestCase> cases = from t in db.TestCases.OfType<SpecialJudgedTestCase>()
                                                       where t.Problem.ID == record.Problem.ID
                                                       select t;
            return tester.TestSpecialJudged(record.Code,record.Language, cases);
        }
    }
}