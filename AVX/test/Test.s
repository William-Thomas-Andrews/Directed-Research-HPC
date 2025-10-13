	.file	"Test.c"
	.text
	.globl	randfrom
	.type	randfrom, @function
randfrom:
.LFB6:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	vmovsd	%xmm0, -24(%rbp)
	vmovsd	%xmm1, -32(%rbp)
	vmovsd	-32(%rbp), %xmm0
	vsubsd	-24(%rbp), %xmm0, %xmm0
	vmovsd	%xmm0, -16(%rbp)
	vmovsd	.LC0(%rip), %xmm0
	vdivsd	-16(%rbp), %xmm0, %xmm0
	vmovsd	%xmm0, -8(%rbp)
	call	rand@PLT
	vcvtsi2sdl	%eax, %xmm0, %xmm0
	vdivsd	-8(%rbp), %xmm0, %xmm0
	vaddsd	-24(%rbp), %xmm0, %xmm0
	vmovq	%xmm0, %rax
	vmovq	%rax, %xmm0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	randfrom, .-randfrom
	.section	.rodata
	.align 8
.LC1:
	.string	"Error: row or col sizes cannot be below 0\n"
	.text
	.type	init_matrix, @function
init_matrix:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movl	%edx, -32(%rbp)
	cmpl	$0, -28(%rbp)
	js	.L4
	cmpl	$0, -32(%rbp)
	jns	.L5
.L4:
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$42, %edx
	movl	$1, %esi
	leaq	.LC1(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L5:
	movl	-28(%rbp), %eax
	imull	-32(%rbp), %eax
	movl	%eax, -4(%rbp)
	movq	-24(%rbp), %rax
	movl	-4(%rbp), %edx
	movl	%edx, 8(%rax)
	movq	-24(%rbp), %rax
	movl	-28(%rbp), %edx
	movl	%edx, 12(%rax)
	movq	-24(%rbp), %rax
	movl	-32(%rbp), %edx
	movl	%edx, 16(%rax)
	movl	-4(%rbp), %eax
	cltq
	movl	$8, %esi
	movq	%rax, %rdi
	call	calloc@PLT
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	movq	%rdx, (%rax)
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	init_matrix, .-init_matrix
	.type	init_matrix_r, @function
init_matrix_r:
.LFB8:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$40, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -40(%rbp)
	movl	%esi, -44(%rbp)
	movl	%edx, -48(%rbp)
	cmpl	$0, -44(%rbp)
	js	.L7
	cmpl	$0, -48(%rbp)
	jns	.L8
.L7:
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$42, %edx
	movl	$1, %esi
	leaq	.LC1(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L8:
	movl	-44(%rbp), %eax
	imull	-48(%rbp), %eax
	movl	%eax, -20(%rbp)
	movq	-40(%rbp), %rax
	movl	-20(%rbp), %edx
	movl	%edx, 8(%rax)
	movq	-40(%rbp), %rax
	movl	-44(%rbp), %edx
	movl	%edx, 12(%rax)
	movq	-40(%rbp), %rax
	movl	-48(%rbp), %edx
	movl	%edx, 16(%rax)
	movl	-20(%rbp), %eax
	cltq
	salq	$3, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, %rdx
	movq	-40(%rbp), %rax
	movq	%rdx, (%rax)
	movl	$0, %edi
	call	time@PLT
	movl	%eax, %edi
	call	srand@PLT
	movl	$0, -24(%rbp)
	jmp	.L9
.L10:
	movq	-40(%rbp), %rax
	movq	(%rax), %rdx
	movl	-24(%rbp), %eax
	cltq
	salq	$3, %rax
	leaq	(%rdx,%rax), %rbx
	vmovsd	.LC2(%rip), %xmm0
	vmovsd	%xmm0, %xmm0, %xmm1
	movq	.LC3(%rip), %rax
	vmovq	%rax, %xmm0
	call	randfrom
	vmovq	%xmm0, %rax
	movq	%rax, (%rbx)
	incl	-24(%rbp)
.L9:
	movl	-24(%rbp), %eax
	cmpl	-20(%rbp), %eax
	jl	.L10
	nop
	nop
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	init_matrix_r, .-init_matrix_r
	.type	transpose, @function
transpose:
.LFB12:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	%rdi, -56(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-56(%rbp), %rax
	movl	12(%rax), %edx
	movq	-56(%rbp), %rax
	movl	16(%rax), %ecx
	leaq	-32(%rbp), %rax
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	init_matrix
	movl	$0, -44(%rbp)
	jmp	.L12
.L15:
	movl	$0, -40(%rbp)
	jmp	.L13
.L14:
	movq	-56(%rbp), %rax
	movq	(%rax), %rdx
	movq	-56(%rbp), %rax
	movl	16(%rax), %eax
	imull	-44(%rbp), %eax
	movl	-40(%rbp), %ecx
	addl	%ecx, %eax
	cltq
	salq	$3, %rax
	addq	%rax, %rdx
	movq	-32(%rbp), %rcx
	movl	-16(%rbp), %eax
	imull	-40(%rbp), %eax
	movl	-44(%rbp), %esi
	addl	%esi, %eax
	cltq
	salq	$3, %rax
	addq	%rcx, %rax
	vmovsd	(%rdx), %xmm0
	vmovsd	%xmm0, (%rax)
	incl	-40(%rbp)
.L13:
	movq	-56(%rbp), %rax
	movl	16(%rax), %eax
	cmpl	%eax, -40(%rbp)
	jl	.L14
	incl	-44(%rbp)
.L12:
	movq	-56(%rbp), %rax
	movl	12(%rax), %eax
	cmpl	%eax, -44(%rbp)
	jl	.L15
	movl	$0, -36(%rbp)
	jmp	.L16
.L17:
	movq	-32(%rbp), %rdx
	movl	-36(%rbp), %eax
	cltq
	salq	$3, %rax
	addq	%rax, %rdx
	movq	-56(%rbp), %rax
	movq	(%rax), %rcx
	movl	-36(%rbp), %eax
	cltq
	salq	$3, %rax
	addq	%rcx, %rax
	vmovsd	(%rdx), %xmm0
	vmovsd	%xmm0, (%rax)
	incl	-36(%rbp)
.L16:
	movl	-24(%rbp), %eax
	cmpl	%eax, -36(%rbp)
	jl	.L17
	movl	-20(%rbp), %edx
	movq	-56(%rbp), %rax
	movl	%edx, 12(%rax)
	movl	-16(%rbp), %edx
	movq	-56(%rbp), %rax
	movl	%edx, 16(%rax)
	movq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	nop
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L18
	call	__stack_chk_fail@PLT
.L18:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	transpose, .-transpose
	.section	.rodata
	.align 8
.LC4:
	.string	"Matrix 1 colums do not match Matrix 2 rows.\n"
	.align 8
.LC5:
	.string	"Result matrix rows do not match Matrix 1 rows.\n"
	.align 8
.LC6:
	.string	"Result matrix columns do not match Matrix 2 columns.\n"
	.text
	.type	matrix_multiply_1, @function
matrix_multiply_1:
.LFB13:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$80, %rsp
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movq	%rdx, -72(%rbp)
	movq	-64(%rbp), %rax
	movl	16(%rax), %eax
	movl	%eax, -24(%rbp)
	movq	-72(%rbp), %rax
	movl	16(%rax), %eax
	movl	%eax, -20(%rbp)
	movq	-64(%rbp), %rax
	movl	12(%rax), %eax
	movl	%eax, -16(%rbp)
	movq	-72(%rbp), %rax
	movl	12(%rax), %eax
	movl	%eax, -12(%rbp)
	movq	-64(%rbp), %rax
	movl	16(%rax), %edx
	movq	-72(%rbp), %rax
	movl	12(%rax), %eax
	cmpl	%eax, %edx
	je	.L20
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$44, %edx
	movl	$1, %esi
	leaq	.LC4(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L20:
	movq	-56(%rbp), %rax
	movl	12(%rax), %eax
	cmpl	%eax, -16(%rbp)
	je	.L21
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$47, %edx
	movl	$1, %esi
	leaq	.LC5(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L21:
	movq	-56(%rbp), %rax
	movl	16(%rax), %eax
	cmpl	%eax, -20(%rbp)
	je	.L22
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$53, %edx
	movl	$1, %esi
	leaq	.LC6(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L22:
	movl	$0, -36(%rbp)
	jmp	.L23
.L28:
	movl	$0, -32(%rbp)
	jmp	.L24
.L27:
	vxorpd	%xmm0, %xmm0, %xmm0
	vmovsd	%xmm0, -8(%rbp)
	movl	$0, -28(%rbp)
	jmp	.L25
.L26:
	movq	-64(%rbp), %rax
	movq	(%rax), %rdx
	movl	-36(%rbp), %eax
	imull	-24(%rbp), %eax
	movl	-28(%rbp), %ecx
	addl	%ecx, %eax
	cltq
	salq	$3, %rax
	addq	%rdx, %rax
	vmovsd	(%rax), %xmm1
	movq	-72(%rbp), %rax
	movq	(%rax), %rdx
	movl	-28(%rbp), %eax
	imull	-20(%rbp), %eax
	movl	-32(%rbp), %ecx
	addl	%ecx, %eax
	cltq
	salq	$3, %rax
	addq	%rdx, %rax
	vmovsd	(%rax), %xmm0
	vmulsd	%xmm0, %xmm1, %xmm0
	vmovsd	-8(%rbp), %xmm1
	vaddsd	%xmm0, %xmm1, %xmm0
	vmovsd	%xmm0, -8(%rbp)
	incl	-28(%rbp)
.L25:
	movl	-28(%rbp), %eax
	cmpl	-12(%rbp), %eax
	jl	.L26
	movq	-56(%rbp), %rax
	movq	(%rax), %rdx
	movl	-36(%rbp), %eax
	imull	-20(%rbp), %eax
	movl	-32(%rbp), %ecx
	addl	%ecx, %eax
	cltq
	salq	$3, %rax
	addq	%rdx, %rax
	vmovsd	-8(%rbp), %xmm0
	vmovsd	%xmm0, (%rax)
	incl	-32(%rbp)
.L24:
	movl	-32(%rbp), %eax
	cmpl	-20(%rbp), %eax
	jl	.L27
	incl	-36(%rbp)
.L23:
	movl	-36(%rbp), %eax
	cmpl	-16(%rbp), %eax
	jl	.L28
	nop
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	matrix_multiply_1, .-matrix_multiply_1
	.globl	bijk
	.type	bijk, @function
bijk:
.LFB31:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	%rdx, -56(%rbp)
	movl	%ecx, -60(%rbp)
	movl	%r8d, -64(%rbp)
	movl	-60(%rbp), %eax
	cltd
	idivl	-64(%rbp)
	movl	%eax, %edx
	movl	-64(%rbp), %eax
	imull	%edx, %eax
	movl	%eax, -12(%rbp)
	movl	$0, -20(%rbp)
	jmp	.L30
.L39:
	movl	$0, -16(%rbp)
	jmp	.L31
.L38:
	movl	$0, -32(%rbp)
	jmp	.L32
.L37:
	movl	-16(%rbp), %eax
	movl	%eax, -28(%rbp)
	jmp	.L33
.L36:
	movq	-40(%rbp), %rax
	movq	(%rax), %rdx
	movq	-40(%rbp), %rax
	movl	16(%rax), %eax
	imull	-32(%rbp), %eax
	movl	-28(%rbp), %ecx
	addl	%ecx, %eax
	cltq
	salq	$3, %rax
	addq	%rdx, %rax
	vmovsd	(%rax), %xmm0
	vmovsd	%xmm0, -8(%rbp)
	movl	-20(%rbp), %eax
	movl	%eax, -24(%rbp)
	jmp	.L34
.L35:
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	-48(%rbp), %rax
	movl	16(%rax), %eax
	imull	-32(%rbp), %eax
	movl	-24(%rbp), %ecx
	addl	%ecx, %eax
	cltq
	salq	$3, %rax
	addq	%rdx, %rax
	vmovsd	(%rax), %xmm1
	movq	-56(%rbp), %rax
	movq	(%rax), %rdx
	movq	-56(%rbp), %rax
	movl	16(%rax), %eax
	imull	-24(%rbp), %eax
	movl	-28(%rbp), %ecx
	addl	%ecx, %eax
	cltq
	salq	$3, %rax
	addq	%rdx, %rax
	vmovsd	(%rax), %xmm0
	vmulsd	%xmm0, %xmm1, %xmm0
	vmovsd	-8(%rbp), %xmm1
	vaddsd	%xmm0, %xmm1, %xmm0
	vmovsd	%xmm0, -8(%rbp)
	incl	-24(%rbp)
.L34:
	movl	-20(%rbp), %edx
	movl	-64(%rbp), %eax
	addl	%edx, %eax
	cmpl	%eax, -24(%rbp)
	jl	.L35
	movq	-40(%rbp), %rax
	movq	(%rax), %rdx
	movq	-40(%rbp), %rax
	movl	16(%rax), %eax
	imull	-32(%rbp), %eax
	movl	-28(%rbp), %ecx
	addl	%ecx, %eax
	cltq
	salq	$3, %rax
	addq	%rdx, %rax
	vmovsd	-8(%rbp), %xmm0
	vmovsd	%xmm0, (%rax)
	incl	-28(%rbp)
.L33:
	movl	-16(%rbp), %edx
	movl	-64(%rbp), %eax
	addl	%edx, %eax
	cmpl	%eax, -28(%rbp)
	jl	.L36
	incl	-32(%rbp)
.L32:
	movl	-32(%rbp), %eax
	cmpl	-60(%rbp), %eax
	jl	.L37
	movl	-64(%rbp), %eax
	addl	%eax, -16(%rbp)
.L31:
	movl	-16(%rbp), %eax
	cmpl	-12(%rbp), %eax
	jl	.L38
	movl	-64(%rbp), %eax
	addl	%eax, -20(%rbp)
.L30:
	movl	-20(%rbp), %eax
	cmpl	-12(%rbp), %eax
	jl	.L39
	nop
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE31:
	.size	bijk, .-bijk
	.section	.rodata
	.align 8
.LC7:
	.string	"Matrix 1 colums do not match Matrix 2 cols (transposition case).\n"
	.text
	.type	matrix_multiply_with_transposed_B, @function
matrix_multiply_with_transposed_B:
.LFB32:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$80, %rsp
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movq	%rdx, -72(%rbp)
	movq	-64(%rbp), %rax
	movl	16(%rax), %eax
	movl	%eax, -24(%rbp)
	movq	-72(%rbp), %rax
	movl	16(%rax), %eax
	movl	%eax, -20(%rbp)
	movq	-64(%rbp), %rax
	movl	12(%rax), %eax
	movl	%eax, -16(%rbp)
	movq	-72(%rbp), %rax
	movl	12(%rax), %eax
	movl	%eax, -12(%rbp)
	movl	-24(%rbp), %eax
	cmpl	-20(%rbp), %eax
	je	.L41
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$65, %edx
	movl	$1, %esi
	leaq	.LC7(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L41:
	movq	-56(%rbp), %rax
	movl	12(%rax), %eax
	cmpl	%eax, -16(%rbp)
	je	.L42
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$47, %edx
	movl	$1, %esi
	leaq	.LC5(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L42:
	movq	-56(%rbp), %rax
	movl	16(%rax), %eax
	cmpl	%eax, -12(%rbp)
	je	.L43
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$53, %edx
	movl	$1, %esi
	leaq	.LC6(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L43:
	movl	$0, -36(%rbp)
	jmp	.L44
.L49:
	movl	$0, -32(%rbp)
	jmp	.L45
.L48:
	vxorpd	%xmm0, %xmm0, %xmm0
	vmovsd	%xmm0, -8(%rbp)
	movl	$0, -28(%rbp)
	jmp	.L46
.L47:
	movq	-64(%rbp), %rax
	movq	(%rax), %rdx
	movl	-36(%rbp), %eax
	imull	-24(%rbp), %eax
	movl	-28(%rbp), %ecx
	addl	%ecx, %eax
	cltq
	salq	$3, %rax
	addq	%rdx, %rax
	vmovsd	(%rax), %xmm1
	movq	-72(%rbp), %rax
	movq	(%rax), %rdx
	movl	-32(%rbp), %eax
	imull	-20(%rbp), %eax
	movl	-28(%rbp), %ecx
	addl	%ecx, %eax
	cltq
	salq	$3, %rax
	addq	%rdx, %rax
	vmovsd	(%rax), %xmm0
	vmulsd	%xmm0, %xmm1, %xmm0
	vmovsd	-8(%rbp), %xmm1
	vaddsd	%xmm0, %xmm1, %xmm0
	vmovsd	%xmm0, -8(%rbp)
	incl	-28(%rbp)
.L46:
	movl	-28(%rbp), %eax
	cmpl	-24(%rbp), %eax
	jl	.L47
	movq	-56(%rbp), %rax
	movq	(%rax), %rdx
	movq	-56(%rbp), %rax
	movl	16(%rax), %eax
	imull	-36(%rbp), %eax
	movl	-32(%rbp), %ecx
	addl	%ecx, %eax
	cltq
	salq	$3, %rax
	addq	%rdx, %rax
	vmovsd	-8(%rbp), %xmm0
	vmovsd	%xmm0, (%rax)
	incl	-32(%rbp)
.L45:
	movl	-32(%rbp), %eax
	cmpl	-12(%rbp), %eax
	jl	.L48
	incl	-36(%rbp)
.L44:
	movl	-36(%rbp), %eax
	cmpl	-16(%rbp), %eax
	jl	.L49
	nop
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE32:
	.size	matrix_multiply_with_transposed_B, .-matrix_multiply_with_transposed_B
	.section	.rodata
	.align 8
.LC8:
	.string	"Error: row and column sizes do not match"
	.align 8
.LC11:
	.string	"DEBUG: %.9Lf and %.9Lf were not the same.\n"
	.text
	.type	cmp_matrix, @function
cmp_matrix:
.LFB36:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	-24(%rbp), %rax
	movl	12(%rax), %edx
	movq	-32(%rbp), %rax
	movl	12(%rax), %eax
	cmpl	%eax, %edx
	je	.L51
	movq	-24(%rbp), %rax
	movl	16(%rax), %edx
	movq	-32(%rbp), %rax
	movl	16(%rax), %eax
	cmpl	%eax, %edx
	je	.L51
	leaq	.LC8(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	movl	$0, %eax
	jmp	.L52
.L51:
	movq	-24(%rbp), %rax
	movl	12(%rax), %edx
	movq	-32(%rbp), %rax
	movl	12(%rax), %eax
	cmpl	%eax, %edx
	je	.L53
	movl	$0, %eax
	jmp	.L52
.L53:
	movq	-24(%rbp), %rax
	movl	16(%rax), %edx
	movq	-32(%rbp), %rax
	movl	16(%rax), %eax
	cmpl	%eax, %edx
	je	.L54
	movl	$0, %eax
	jmp	.L52
.L54:
	movq	-24(%rbp), %rax
	movl	8(%rax), %edx
	movq	-32(%rbp), %rax
	movl	8(%rax), %eax
	cmpl	%eax, %edx
	je	.L55
	movl	$0, %eax
	jmp	.L52
.L55:
	movl	$0, -4(%rbp)
	jmp	.L56
.L60:
	movq	-24(%rbp), %rax
	movq	(%rax), %rdx
	movl	-4(%rbp), %eax
	cltq
	salq	$3, %rax
	addq	%rdx, %rax
	vmovsd	(%rax), %xmm0
	movq	-32(%rbp), %rax
	movq	(%rax), %rdx
	movl	-4(%rbp), %eax
	cltq
	salq	$3, %rax
	addq	%rdx, %rax
	vmovsd	(%rax), %xmm1
	vsubsd	%xmm1, %xmm0, %xmm0
	vcomisd	.LC9(%rip), %xmm0
	ja	.L57
	movq	-24(%rbp), %rax
	movq	(%rax), %rdx
	movl	-4(%rbp), %eax
	cltq
	salq	$3, %rax
	addq	%rdx, %rax
	vmovsd	(%rax), %xmm0
	movq	-32(%rbp), %rax
	movq	(%rax), %rdx
	movl	-4(%rbp), %eax
	cltq
	salq	$3, %rax
	addq	%rdx, %rax
	vmovsd	(%rax), %xmm1
	vsubsd	%xmm1, %xmm0, %xmm0
	vmovsd	.LC10(%rip), %xmm1
	vcomisd	%xmm0, %xmm1
	jbe	.L61
.L57:
	movq	-32(%rbp), %rax
	movq	(%rax), %rdx
	movl	-4(%rbp), %eax
	cltq
	salq	$3, %rax
	addq	%rdx, %rax
	vmovsd	(%rax), %xmm0
	movq	-24(%rbp), %rax
	movq	(%rax), %rdx
	movl	-4(%rbp), %eax
	cltq
	salq	$3, %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	vmovsd	%xmm0, %xmm0, %xmm1
	vmovq	%rax, %xmm0
	leaq	.LC11(%rip), %rax
	movq	%rax, %rdi
	movl	$2, %eax
	call	printf@PLT
	movl	$0, %eax
	jmp	.L52
.L61:
	incl	-4(%rbp)
.L56:
	movq	-24(%rbp), %rax
	movl	8(%rax), %eax
	cmpl	%eax, -4(%rbp)
	jl	.L60
	movl	$1, %eax
.L52:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE36:
	.size	cmp_matrix, .-cmp_matrix
	.globl	avx_matrix_multiply
	.type	avx_matrix_multiply, @function
avx_matrix_multiply:
.LFB4234:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	andq	$-64, %rsp
	subq	$768, %rsp
	movq	%rdi, 40(%rsp)
	movq	%rsi, 32(%rsp)
	movq	%rdx, 24(%rsp)
	movq	%fs:40, %rax
	movq	%rax, 760(%rsp)
	xorl	%eax, %eax
	movq	32(%rsp), %rax
	movl	16(%rax), %edx
	movq	24(%rsp), %rax
	movl	12(%rax), %eax
	cmpl	%eax, %edx
	je	.L63
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$44, %edx
	movl	$1, %esi
	leaq	.LC4(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L63:
	movq	40(%rsp), %rax
	movl	12(%rax), %edx
	movq	32(%rsp), %rax
	movl	12(%rax), %eax
	cmpl	%eax, %edx
	je	.L64
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$47, %edx
	movl	$1, %esi
	leaq	.LC5(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L64:
	movq	40(%rsp), %rax
	movl	16(%rax), %edx
	movq	24(%rsp), %rax
	movl	16(%rax), %eax
	cmpl	%eax, %edx
	je	.L65
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$53, %edx
	movl	$1, %esi
	leaq	.LC6(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L65:
	movq	24(%rsp), %rax
	movq	%rax, %rdi
	call	transpose
	movq	32(%rsp), %rax
	movl	16(%rax), %eax
	movl	%eax, 72(%rsp)
	movq	24(%rsp), %rax
	movl	16(%rax), %eax
	movl	%eax, 76(%rsp)
	movq	32(%rsp), %rax
	movl	12(%rax), %eax
	movl	%eax, 80(%rsp)
	movq	24(%rsp), %rax
	movl	12(%rax), %eax
	movl	%eax, 84(%rsp)
	movl	$0, 60(%rsp)
	jmp	.L66
.L77:
	movl	$0, 64(%rsp)
	jmp	.L67
.L76:
	vxorpd	%xmm0, %xmm0, %xmm0
	vmovsd	%xmm0, 88(%rsp)
	movl	$0, 68(%rsp)
	jmp	.L68
.L75:
	movq	32(%rsp), %rax
	movq	(%rax), %rdx
	movl	60(%rsp), %eax
	imull	72(%rsp), %eax
	movl	68(%rsp), %ecx
	addl	%ecx, %eax
	cltq
	salq	$3, %rax
	addq	%rdx, %rax
	movq	%rax, 104(%rsp)
	movq	104(%rsp), %rax
	vmovupd	(%rax), %zmm0
	vmovapd	%zmm0, 320(%rsp)
	movq	24(%rsp), %rax
	movq	(%rax), %rdx
	movl	64(%rsp), %eax
	imull	72(%rsp), %eax
	movl	68(%rsp), %ecx
	addl	%ecx, %eax
	cltq
	salq	$3, %rax
	addq	%rdx, %rax
	movq	%rax, 96(%rsp)
	movq	96(%rsp), %rax
	vmovupd	(%rax), %zmm0
	vmovapd	%zmm0, 384(%rsp)
	vmovapd	320(%rsp), %zmm0
	vmovapd	%zmm0, 576(%rsp)
	vmovapd	384(%rsp), %zmm0
	vmovapd	%zmm0, 640(%rsp)
	vmovapd	576(%rsp), %zmm0
	vmulpd	640(%rsp), %zmm0, %zmm0
	vmovapd	%zmm0, 448(%rsp)
	vmovapd	448(%rsp), %zmm0
	vmovapd	%zmm0, 512(%rsp)
	vmovapd	160(%rsp), %ymm1
	vmovapd	512(%rsp), %zmm0
	movl	$-1, %eax
	kmovb	%eax, %k1
	vextractf64x4	$0x1, %zmm0, %ymm1{%k1}
	vmovapd	%ymm1, 192(%rsp)
	vmovapd	224(%rsp), %ymm1
	vmovapd	512(%rsp), %zmm0
	movl	$-1, %eax
	kmovb	%eax, %k2
	vextractf64x4	$0x0, %zmm0, %ymm1{%k2}
	vmovapd	%ymm1, 256(%rsp)
	vmovapd	192(%rsp), %ymm0
	vaddpd	256(%rsp), %ymm0, %ymm0
	vmovapd	%ymm0, 288(%rsp)
	vmovapd	288(%rsp), %ymm0
	vextractf64x2	$0x1, %ymm0, 128(%rsp)
	vmovapd	288(%rsp), %ymm0
	vmovapd	%xmm0, 144(%rsp)
	vmovapd	128(%rsp), %xmm0
	vaddpd	144(%rsp), %xmm0, %xmm0
	vmovapd	%xmm0, 112(%rsp)
	vmovsd	112(%rsp), %xmm1
	vmovsd	120(%rsp), %xmm0
	vaddsd	%xmm0, %xmm1, %xmm0
	vmovsd	88(%rsp), %xmm1
	vaddsd	%xmm0, %xmm1, %xmm0
	vmovsd	%xmm0, 88(%rsp)
	addl	$8, 68(%rsp)
.L68:
	movl	68(%rsp), %eax
	cmpl	72(%rsp), %eax
	jl	.L75
	movq	40(%rsp), %rax
	movq	(%rax), %rdx
	movl	60(%rsp), %eax
	imull	84(%rsp), %eax
	movl	64(%rsp), %ecx
	addl	%ecx, %eax
	cltq
	salq	$3, %rax
	addq	%rdx, %rax
	vmovsd	88(%rsp), %xmm0
	vmovsd	%xmm0, (%rax)
	incl	64(%rsp)
.L67:
	movl	64(%rsp), %eax
	cmpl	84(%rsp), %eax
	jl	.L76
	incl	60(%rsp)
.L66:
	movl	60(%rsp), %eax
	cmpl	80(%rsp), %eax
	jl	.L77
	nop
	movq	760(%rsp), %rax
	subq	%fs:40, %rax
	je	.L78
	call	__stack_chk_fail@PLT
.L78:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4234:
	.size	avx_matrix_multiply, .-avx_matrix_multiply
	.section	.rodata
	.align 8
.LC13:
	.string	"The standard Matrix Multiplication took %.6Lf s\n"
	.align 8
.LC14:
	.string	"The avx512 instrinsics took %.6Lf s\n"
.LC15:
	.string	"Yay the matrix is correct!"
	.align 8
.LC16:
	.string	"The cache-friendly transposition function took %.6Lf s\n"
	.text
	.globl	run_tests
	.type	run_tests, @function
run_tests:
.LFB4235:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$224, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$2048, -208(%rbp)
	movl	$2048, -204(%rbp)
	movl	$2048, -200(%rbp)
	movl	$2048, -196(%rbp)
	movl	-204(%rbp), %edx
	movl	-208(%rbp), %ecx
	leaq	-160(%rbp), %rax
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	init_matrix_r
	movl	$2, %edi
	call	sleep@PLT
	movl	-196(%rbp), %edx
	movl	-200(%rbp), %ecx
	leaq	-128(%rbp), %rax
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	init_matrix_r
	movl	-196(%rbp), %edx
	movl	-208(%rbp), %ecx
	leaq	-96(%rbp), %rax
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	init_matrix
	movl	-196(%rbp), %edx
	movl	-208(%rbp), %ecx
	leaq	-64(%rbp), %rax
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	init_matrix
	movl	-196(%rbp), %edx
	movl	-208(%rbp), %ecx
	leaq	-32(%rbp), %rax
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	init_matrix
	call	clock@PLT
	movq	%rax, -192(%rbp)
	leaq	-128(%rbp), %rdx
	leaq	-160(%rbp), %rcx
	leaq	-96(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	matrix_multiply_1
	call	clock@PLT
	movq	%rax, -184(%rbp)
	movq	-184(%rbp), %rax
	subq	-192(%rbp), %rax
	vcvtsi2sdq	%rax, %xmm0, %xmm0
	vmovsd	.LC12(%rip), %xmm1
	vdivsd	%xmm1, %xmm0, %xmm2
	vmovsd	%xmm2, -216(%rbp)
	fldl	-216(%rbp)
	fstpt	-176(%rbp)
	pushq	-168(%rbp)
	pushq	-176(%rbp)
	leaq	.LC13(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	addq	$16, %rsp
	call	clock@PLT
	movq	%rax, -192(%rbp)
	leaq	-128(%rbp), %rdx
	leaq	-160(%rbp), %rcx
	leaq	-64(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	avx_matrix_multiply
	call	clock@PLT
	movq	%rax, -184(%rbp)
	movq	-184(%rbp), %rax
	subq	-192(%rbp), %rax
	vcvtsi2sdq	%rax, %xmm0, %xmm0
	vmovsd	.LC12(%rip), %xmm1
	vdivsd	%xmm1, %xmm0, %xmm3
	vmovsd	%xmm3, -216(%rbp)
	fldl	-216(%rbp)
	fstpt	-176(%rbp)
	pushq	-168(%rbp)
	pushq	-176(%rbp)
	leaq	.LC14(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	addq	$16, %rsp
	leaq	-64(%rbp), %rdx
	leaq	-96(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	cmp_matrix
	cmpl	$1, %eax
	jne	.L80
	leaq	.LC15(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
.L80:
	leaq	-128(%rbp), %rax
	movq	%rax, %rdi
	call	transpose
	call	clock@PLT
	movq	%rax, -192(%rbp)
	leaq	-128(%rbp), %rax
	movq	%rax, %rdi
	call	transpose
	leaq	-128(%rbp), %rdx
	leaq	-160(%rbp), %rcx
	leaq	-32(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	matrix_multiply_with_transposed_B
	call	clock@PLT
	movq	%rax, -184(%rbp)
	movq	-184(%rbp), %rax
	subq	-192(%rbp), %rax
	vcvtsi2sdq	%rax, %xmm0, %xmm0
	vmovsd	.LC12(%rip), %xmm1
	vdivsd	%xmm1, %xmm0, %xmm4
	vmovsd	%xmm4, -216(%rbp)
	fldl	-216(%rbp)
	fstpt	-176(%rbp)
	pushq	-168(%rbp)
	pushq	-176(%rbp)
	leaq	.LC16(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	addq	$16, %rsp
	leaq	-32(%rbp), %rdx
	leaq	-96(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	cmp_matrix
	cmpl	$1, %eax
	jne	.L81
	leaq	.LC15(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
.L81:
	leaq	-128(%rbp), %rax
	movq	%rax, %rdi
	call	transpose
	movl	$0, %eax
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L83
	call	__stack_chk_fail@PLT
.L83:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4235:
	.size	run_tests, .-run_tests
	.section	.rodata
	.align 8
.LC0:
	.long	-4194304
	.long	1105199103
	.align 8
.LC2:
	.long	0
	.long	1073741824
	.align 8
.LC3:
	.long	0
	.long	0
	.align 8
.LC9:
	.long	1202590843
	.long	1065646817
	.align 8
.LC10:
	.long	1202590843
	.long	-1081836831
	.align 8
.LC12:
	.long	0
	.long	1093567616
	.ident	"GCC: (Ubuntu 11.4.0-1ubuntu1~22.04.2) 11.4.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
