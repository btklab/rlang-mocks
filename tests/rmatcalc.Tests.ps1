BeforeAll {
    $com = "$PSScriptRoot/../src/rmatcalc.R"
    if ( $IsWindows ){
        $rscript = "Rscript"
    } else {
        $rscript = "Rscript"
    }
}

Describe "rmatcalc.R" {
    Context "when value from pipeline received" {
        It "calculate matrix: A%*%B" {
            [string[]] $stdin  = @(
                "A 1 2",
                "A 3 4",
                "B 4 3",
                "B 2 1"
            )
            [string[]] $stdout = @(
                "A 1 2",
                "A 3 4",
                "B 4 3",
                "B 2 1",
                "C 8 5",
                "C 20 13"
            )
            $stdin | & $rscript $com -f 'A%*%B' | Should -Be $stdout
        }
        It "calculate matrix: A*B" {
            [string[]] $stdin  = @(
                "A 1 2",
                "A 3 4",
                "B 4 3",
                "B 2 1"
            )
            [string[]] $stdout = @(
                "A 1 2",
                "A 3 4",
                "B 4 3",
                "B 2 1",
                "C 4 6",
                "C 6 4"
            )
            $stdin | & $rscript $com -f 'A*B' | Should -Be $stdout
        }
        It "calculate matrix: transpose" {
            [string[]] $stdin  = @(
                "A 1 2",
                "A 3 4"
            )
            [string[]] $stdout = @(
                "A 1 2",
                "A 3 4",
                "B 1 3",
                "B 2 4"
            )
            $stdin | & $rscript $com -f 't(A)' | Should -Be $stdout
        }
        It "calculate matrix: solve" {
            [string[]] $stdin  = @(
                "A 1 1",
                "A 2 4"
            )
            [string[]] $stdout = @(
                "A 1 1",
                "A 2 4",
                "B 1 0",
                "B 0 1"
            )
            $stdin | & $rscript $com -f 'A%*%solve(A)' | Should -Be $stdout
        }
        It "calculate matrix: add specify label" {
            [string[]] $stdin  = @(
                "A 1 2",
                "A 3 4",
                "B 4 3",
                "B 2 1"
            )
            [string[]] $stdout = @(
                "A 1 2",
                "A 3 4",
                "B 4 3",
                "B 2 1",
                "C 4 6",
                "C 6 4"
            )
            $stdin | & $rscript $com -f 'C=A*B' | Should -Be $stdout
        }
        It "calculate matrix: determinant" {
            [string[]] $stdin  = @(
                "A 2 -6 4",
                "A 7 2 3",
                "A 8 5 -1"
            )
            [string[]] $stdout = @(
                "A 2 -6 4",
                "A 7 2 3",
                "A 8 5 -1",
                "C -144"
            )
            $stdin | & $rscript $com -f 'C=det(A)*diag(1)' | Should -Be $stdout
        }
        It "calculate matrix: rank" {
            [string[]] $stdin  = @(
                "A 2 -6 4",
                "A 7 2 3",
                "A 8 5 -1"
            )
            [string[]] $stdout = @(
                "A 2 -6 4",
                "A 7 2 3",
                "A 8 5 -1",
                "C 3"
            )
            $stdin | & $rscript $com -f 'C=qr(A)$rank*diag(1)' | Should -Be $stdout
        }
        It "calculate matrix: chain calc using pipe" {
            [string[]] $stdin  = @(
                "A 1 2",
                "A 3 4",
                "B 4 3",
                "B 2 1"
            )
            [string[]] $stdout = @(
                "A 1 2",
                "A 3 4",
                "B 4 3",
                "B 2 1",
                "C 4 6",
                "C 6 4",
                "E 22 32",
                "E 18 28"
            )
            $stdin | & $rscript $com -f 'C=A*B' | & $rscript $com -f 'E=C%*%A' | Should -Be $stdout
        }
    }
}

